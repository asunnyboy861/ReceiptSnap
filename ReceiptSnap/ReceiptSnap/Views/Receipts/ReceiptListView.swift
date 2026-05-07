import SwiftUI
import SwiftData

struct ReceiptListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Receipt.createdAt, order: .reverse) private var receipts: [Receipt]
    @State private var searchText = ""
    @State private var selectedCategory: ReceiptCategory?
    @State private var showPaywall = false

    var filteredReceipts: [Receipt] {
        var result = receipts
        if let category = selectedCategory {
            result = result.filter { $0.category == category.rawValue }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.merchantName.localizedCaseInsensitiveContains(searchText) ||
                $0.rawText.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryFilter

                if filteredReceipts.isEmpty {
                    ContentUnavailableView(
                        "No Receipts",
                        systemImage: "doc.text",
                        description: Text("Scan your first receipt to get started")
                    )
                } else {
                    List(filteredReceipts) { receipt in
                        NavigationLink(value: receipt) {
                            ReceiptCardView(receipt: receipt)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Receipts")
            .searchable(text: $searchText, prompt: "Search receipts...")
            .navigationDestination(for: Receipt.self) { receipt in
                ReceiptDetailView(receipt: receipt, isNew: false)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !PurchaseManager.shared.isPremium {
                        Button("Upgrade") {
                            showPaywall = true
                        }
                        .tint(.blue)
                    }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(ReceiptCategory.allCases, id: \.self) { category in
                    FilterChip(
                        label: category.rawValue,
                        isSelected: selectedCategory == category,
                        icon: category.icon
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }
                Text(label)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}
