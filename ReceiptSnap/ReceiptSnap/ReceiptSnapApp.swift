import SwiftUI
import SwiftData

@main
struct ReceiptSnapApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: Receipt.self)
    }
}
