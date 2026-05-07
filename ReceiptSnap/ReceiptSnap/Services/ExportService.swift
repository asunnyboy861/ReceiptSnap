import Foundation

struct ExportService {
    static func exportToCSV(receipts: [Receipt]) -> URL? {
        var csv = "Merchant,Date,Category,Total,Tax,Notes\n"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        for receipt in receipts {
            let merchant = receipt.merchantName.replacingOccurrences(of: ",", with: ";")
            let date = formatter.string(from: receipt.date)
            let category = receipt.category
            let total = String(format: "%.2f", receipt.totalAmount)
            let tax = String(format: "%.2f", receipt.taxAmount)
            let notes = receipt.notes.replacingOccurrences(of: ",", with: ";").replacingOccurrences(of: "\n", with: " ")
            csv += "\(merchant),\(date),\(category),\(total),\(tax),\(notes)\n"
        }

        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("ReceiptSnap_Export_\(Int(Date().timeIntervalSince1970)).csv")

        do {
            try csv.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("CSV export failed: \(error)")
            return nil
        }
    }
}
