import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ScannerTabView()
                .tabItem {
                    Label("Scan", systemImage: "camera")
                }
                .tag(0)

            ReceiptListView()
                .tabItem {
                    Label("Receipts", systemImage: "doc.text")
                }
                .tag(1)

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.pie")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }
    }
}
