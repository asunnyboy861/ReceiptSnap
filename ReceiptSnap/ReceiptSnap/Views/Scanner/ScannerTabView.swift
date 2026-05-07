import SwiftUI
import SwiftData
import VisionKit

struct ScannerTabView: View {
    @State private var isScanning = false
    @State private var scannedReceipt: Receipt?
    @State private var showPaywall = false
    @Environment(\.modelContext) private var modelContext
    @State private var currentMonthScanCount = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "doc.text.viewfinder")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue.gradient)

                Text("Snap It. Sync It. Done.")
                    .font(.title2.bold())
                    .foregroundStyle(.secondary)

                Button(action: startScanning) {
                    Label("Scan Receipt", systemImage: "camera.fill")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if !PurchaseManager.shared.isPremium {
                    Text("\(max(0, 10 - currentMonthScanCount)) free scans remaining this month")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                RecentReceiptsList()
            }
            .navigationTitle("ReceiptSnap")
            .sheet(isPresented: $isScanning) {
                ScannerRepresentable { receipt in
                    scannedReceipt = receipt
                }
            }
            .sheet(item: $scannedReceipt) { receipt in
                NavigationStack {
                    ReceiptDetailView(receipt: receipt, isNew: true)
                        .environment(\.modelContext, modelContext)
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .onAppear {
                calculateScanCount()
            }
        }
    }

    private func startScanning() {
        if !PurchaseManager.shared.isPremium && currentMonthScanCount >= 10 {
            showPaywall = true
            return
        }
        isScanning = true
    }

    private func calculateScanCount() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let descriptor = FetchDescriptor<Receipt>(
            predicate: #Predicate { $0.createdAt >= startOfMonth }
        )
        if let count = try? modelContext.fetchCount(descriptor) {
            currentMonthScanCount = count
        }
    }
}

struct RecentReceiptsList: View {
    @Query(sort: \Receipt.createdAt, order: .reverse) private var receipts: [Receipt]

    var body: some View {
        if !receipts.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Recent Receipts")
                    .font(.headline)
                    .padding(.horizontal)

                ForEach(Array(receipts.prefix(3))) { receipt in
                    ReceiptCardView(receipt: receipt)
                }
            }
        }
    }
}
