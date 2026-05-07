import Foundation
import SwiftData

@Model
final class Receipt {
    var id: UUID
    var merchantName: String
    var totalAmount: Double
    var taxAmount: Double
    var date: Date
    var category: String
    var rawText: String
    var imageData: Data?
    var isVerified: Bool
    var syncStatus: String
    var createdAt: Date
    var notes: String

    init(
        id: UUID = UUID(),
        merchantName: String = "Unknown",
        totalAmount: Double = 0,
        taxAmount: Double = 0,
        date: Date = Date(),
        category: String = ReceiptCategory.other.rawValue,
        rawText: String = "",
        imageData: Data? = nil,
        isVerified: Bool = false,
        syncStatus: String = "pending",
        createdAt: Date = Date(),
        notes: String = ""
    ) {
        self.id = id
        self.merchantName = merchantName
        self.totalAmount = totalAmount
        self.taxAmount = taxAmount
        self.date = date
        self.category = category
        self.rawText = rawText
        self.imageData = imageData
        self.isVerified = isVerified
        self.syncStatus = syncStatus
        self.createdAt = createdAt
        self.notes = notes
    }
}
