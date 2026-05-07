import SwiftUI
import SwiftData

struct ReceiptDetailView: View {
    @Bindable var receipt: Receipt
    let isNew: Bool
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingImage = false

    var body: some View {
        Form {
            Section("Receipt Info") {
                LabeledContent("Merchant", value: receipt.merchantName)
                LabeledContent("Total") {
                    Text(receipt.totalAmount, format: .currency(code: "USD"))
                        .bold()
                }
                LabeledContent("Tax") {
                    if receipt.taxAmount > 0 {
                        Text(receipt.taxAmount, format: .currency(code: "USD"))
                    } else {
                        Text("N/A").foregroundStyle(.secondary)
                    }
                }
                LabeledContent("Date") {
                    Text(receipt.date, style: .date)
                }
            }

            Section("Category") {
                Picker("Category", selection: $receipt.category) {
                    ForEach(ReceiptCategory.allCases, id: \.rawValue) { cat in
                        Label(cat.rawValue, systemImage: cat.icon).tag(cat.rawValue)
                    }
                }
            }

            Section("Status") {
                HStack {
                    Label("Verified", systemImage: receipt.isVerified ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(receipt.isVerified ? .green : .secondary)
                    Spacer()
                    Toggle("", isOn: $receipt.isVerified)
                        .labelsHidden()
                }

                LabeledContent("Sync") {
                    Text(receipt.syncStatus.capitalized)
                        .font(.subheadline)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(syncColor.opacity(0.2))
                        .foregroundStyle(syncColor)
                        .clipShape(Capsule())
                }
            }

            Section("Notes") {
                TextField("Add notes...", text: $receipt.notes, axis: .vertical)
                    .lineLimit(3...6)
            }

            if receipt.imageData != nil {
                Section("Receipt Image") {
                    Button("View Receipt Image") {
                        showingImage = true
                    }
                }
            }

            if !receipt.rawText.isEmpty {
                Section("OCR Text") {
                    Text(receipt.rawText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(isNew ? "New Receipt" : "Edit Receipt")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        modelContext.insert(receipt)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImage) {
            if let data = receipt.imageData, let uiImage = UIImage(data: data) {
                ImageViewer(image: uiImage)
            }
        }
    }

    private var syncColor: Color {
        switch receipt.syncStatus {
        case "synced": return .green
        case "failed": return .red
        default: return .orange
        }
    }
}

struct ImageViewer: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .navigationTitle("Receipt Image")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}
