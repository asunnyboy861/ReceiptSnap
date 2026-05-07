import Foundation
import StoreKit

@Observable
class PurchaseManager {
    static let shared = PurchaseManager()

    var isPremium = false
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []

    private let productIDs = [
        "com.zzoutuo.ReceiptSnap.monthly",
        "com.zzoutuo.ReceiptSnap.yearly",
        "com.zzoutuo.ReceiptSnap.lifetime"
    ]

    private var transactionListener: Task<Void, Never>?

    private init() {
        transactionListener = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchaseStatus()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updatePurchaseStatus()
                await transaction.finish()
                return true
            case .userCancelled, .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
        } catch {
            print("Restore failed: \(error)")
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self = self else { return }
                if let transaction = try? self.checkVerified(result) {
                    await self.updatePurchaseStatus()
                    await transaction.finish()
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    private func updatePurchaseStatus() async {
        var purchasedIDs: Set<String> = []
        for productID in productIDs {
            if let result = await Transaction.currentEntitlement(for: productID),
               let transaction = try? checkVerified(result) {
                purchasedIDs.insert(transaction.productID)
            }
        }
        purchasedProductIDs = purchasedIDs
        isPremium = !purchasedIDs.isEmpty
    }
}

enum StoreError: Error {
    case failedVerification
}
