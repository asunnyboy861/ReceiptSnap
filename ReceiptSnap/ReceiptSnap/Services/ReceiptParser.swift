import UIKit

struct ReceiptParser {
    static func parse(from text: String, image: UIImage? = nil) -> Receipt {
        let merchantName = extractMerchantName(from: text)
        let totalAmount = extractTotalAmount(from: text)
        let taxAmount = extractTaxAmount(from: text)
        let date = extractDate(from: text)
        let category = ReceiptCategory.categorize(merchant: merchantName, text: text)

        return Receipt(
            merchantName: merchantName,
            totalAmount: totalAmount,
            taxAmount: taxAmount,
            date: date,
            category: category.rawValue,
            rawText: text,
            imageData: image?.jpegData(compressionQuality: 0.8),
            isVerified: false,
            syncStatus: "pending",
            createdAt: Date(),
            notes: ""
        )
    }

    private static func extractMerchantName(from text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        guard let firstLine = lines.first else { return "Unknown" }
        let cleanLine = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
        return cleanLine.count > 50 ? "Unknown" : cleanLine
    }

    private static func extractTotalAmount(from text: String) -> Double {
        let patterns = [
            "total[:\\s]*\\$?([0-9]+\\.?[0-9]*)",
            "amount[:\\s]*\\$?([0-9]+\\.?[0-9]*)",
            "balance[:\\s]*\\$?([0-9]+\\.?[0-9]*)"
        ]

        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
               let match = regex.matches(in: text, range: NSRange(text.startIndex..., in: text)).last,
               let range = Range(match.range(at: 1), in: text),
               let amount = Double(text[range]) {
                return amount
            }
        }
        return 0
    }

    private static func extractTaxAmount(from text: String) -> Double {
        let pattern = "tax[:\\s]*\\$?([0-9]+\\.?[0-9]*)"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
           let match = regex.matches(in: text, range: NSRange(text.startIndex..., in: text)).first,
           let range = Range(match.range(at: 1), in: text),
           let amount = Double(text[range]) {
            return amount
        }
        return 0
    }

    private static func extractDate(from text: String) -> Date {
        let patterns = [
            "(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/(20[0-9]{2})",
            "(20[0-9]{2})-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])",
            "(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\\.?\\s+(0?[1-9]|[12][0-9]|3[01]),?\\s+(20[0-9]{2})"
        ]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        for (index, pattern) in patterns.enumerated() {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
               let match = regex.matches(in: text, range: NSRange(text.startIndex..., in: text)).first,
               let range = Range(match.range, in: text) {
                let dateString = String(text[range])
                switch index {
                case 0: formatter.dateFormat = "MM/dd/yyyy"
                case 1: formatter.dateFormat = "yyyy-MM-dd"
                case 2: formatter.dateFormat = "MMMM dd, yyyy"
                default: continue
                }
                if let date = formatter.date(from: dateString) { return date }
            }
        }
        return Date()
    }
}
