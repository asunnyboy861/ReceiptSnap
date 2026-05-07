import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProduct: Product?
    @State private var isPurchasing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresSection
                    pricingSection
                    ctaButton
                    footerSection
                }
                .padding()
            }
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
            .navigationTitle("Upgrade to Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .task {
                await PurchaseManager.shared.loadProducts()
                selectedProduct = PurchaseManager.shared.products.first { $0.id == "com.zzoutuo.ReceiptSnap.yearly" }
                    ?? PurchaseManager.shared.products.first
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 48))
                .foregroundStyle(.yellow.gradient)

            Text("Unlock Full Power")
                .font(.title.bold())

            Text("Get unlimited scans, smart reminders, and more")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            FeatureRow(icon: "infinity", title: "Unlimited Scans", description: "No monthly limits")
            FeatureRow(icon: "bell.badge", title: "Smart Reminders", description: "Location & habit-based alerts")
            FeatureRow(icon: "chart.pie", title: "Full Analytics", description: "Category breakdowns & trends")
            FeatureRow(icon: "icloud", title: "iCloud Sync", description: "Sync across all devices")
            FeatureRow(icon: "square.and.arrow.up", title: "All Exports", description: "CSV, PDF, Google Sheets")
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var pricingSection: some View {
        VStack(spacing: 12) {
            ForEach(PurchaseManager.shared.products, id: \.id) { product in
                PricingOptionCard(
                    product: product,
                    isSelected: selectedProduct?.id == product.id,
                    isBestValue: product.id == "com.zzoutuo.ReceiptSnap.yearly",
                    onTap: { selectedProduct = product }
                )
            }
        }
    }

    private var ctaButton: some View {
        Button(action: purchase) {
            if isPurchasing {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            } else {
                Text("Subscribe Now")
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .disabled(isPurchasing || selectedProduct == nil)
    }

    private var footerSection: some View {
        VStack(spacing: 8) {
            Text("7-day free trial included")
                .font(.caption)
                .foregroundStyle(.secondary)

            Button("Restore Purchases") {
                Task {
                    await PurchaseManager.shared.restorePurchases()
                    if PurchaseManager.shared.isPremium {
                        dismiss()
                    }
                }
            }
            .font(.caption)
            .foregroundStyle(.blue)

            Text("Cancel anytime in Settings > Subscriptions")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }

    private func purchase() {
        guard let product = selectedProduct else { return }
        isPurchasing = true
        Task {
            let success = await PurchaseManager.shared.purchase(product)
            isPurchasing = false
            if success {
                dismiss()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct PricingOptionCard: View {
    let product: Product
    let isSelected: Bool
    let isBestValue: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.displayName)
                            .font(.subheadline.bold())
                        if isBestValue {
                            Text("Best Value")
                                .font(.caption2.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.green.opacity(0.2))
                                .foregroundStyle(.green)
                                .clipShape(Capsule())
                        }
                    }
                    Text(product.displayPrice)
                        .font(.title3.bold())
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .blue : .secondary)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
