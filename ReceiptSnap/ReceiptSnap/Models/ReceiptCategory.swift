import Foundation

enum ReceiptCategory: String, Codable, CaseIterable {
    case meals = "Meals & Entertainment"
    case travel = "Travel"
    case office = "Office Supplies"
    case fuel = "Fuel & Transportation"
    case software = "Software & Subscriptions"
    case marketing = "Marketing & Advertising"
    case utilities = "Utilities"
    case insurance = "Insurance"
    case professional = "Professional Services"
    case other = "Other"

    var icon: String {
        switch self {
        case .meals: return "fork.knife"
        case .travel: return "airplane"
        case .office: return "paperclip"
        case .fuel: return "fuelpump.fill"
        case .software: return "desktopcomputer"
        case .marketing: return "megaphone"
        case .utilities: return "bolt.fill"
        case .insurance: return "shield"
        case .professional: return "briefcase"
        case .other: return "doc"
        }
    }

    var color: String {
        switch self {
        case .meals: return "orange"
        case .travel: return "blue"
        case .office: return "brown"
        case .fuel: return "red"
        case .software: return "purple"
        case .marketing: return "pink"
        case .utilities: return "yellow"
        case .insurance: return "green"
        case .professional: return "indigo"
        case .other: return "gray"
        }
    }

    static func categorize(merchant: String, text: String) -> ReceiptCategory {
        let lowerMerchant = merchant.lowercased()
        let lowerText = text.lowercased()

        let categoryKeywords: [ReceiptCategory: [String]] = [
            .meals: ["restaurant", "cafe", "coffee", "pizza", "burger", "diner", "grill", "bakery", "starbucks", "dunkin", "chipotle", "mcdonald"],
            .travel: ["airline", "hotel", "motel", "uber", "lyft", "flight", "airbnb", "marriott", "hilton"],
            .fuel: ["shell", "exxon", "chevron", "bp", "gas", "fuel", "station", "sunoco"],
            .office: ["staples", "office depot", "amazon", "best buy", "paper", "ink", "toner"],
            .software: ["apple", "google", "microsoft", "adobe", "subscription", "saas", "app store"],
            .marketing: ["facebook", "google ads", "instagram", "linkedin", "advertising"],
            .utilities: ["electric", "water", "gas bill", "internet", "phone", "verizon", "at&t"],
            .insurance: ["insurance", "geico", "state farm", "allstate", "progressive"],
            .professional: ["legal", "consulting", "accounting", "cpa", "attorney"]
        ]

        for (category, keywords) in categoryKeywords {
            for keyword in keywords {
                if lowerMerchant.contains(keyword) || lowerText.contains(keyword) {
                    return category
                }
            }
        }
        return .other
    }
}
