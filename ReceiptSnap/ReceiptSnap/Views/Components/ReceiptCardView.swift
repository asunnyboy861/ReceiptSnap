import SwiftUI

struct ReceiptCardView: View {
    let receipt: Receipt

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: categoryIcon)
                .font(.title2)
                .foregroundStyle(categoryColor)
                .frame(width: 44, height: 44)
                .background(categoryColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(receipt.merchantName)
                    .font(.subheadline.bold())
                    .lineLimit(1)

                Text(receipt.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(receipt.totalAmount, format: .currency(code: "USD"))
                    .font(.subheadline.bold())

                if receipt.isVerified {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var categoryIcon: String {
        ReceiptCategory(rawValue: receipt.category)?.icon ?? "doc"
    }

    private var categoryColor: Color {
        let colorName = ReceiptCategory(rawValue: receipt.category)?.color ?? "gray"
        return Color(colorName)
    }
}
