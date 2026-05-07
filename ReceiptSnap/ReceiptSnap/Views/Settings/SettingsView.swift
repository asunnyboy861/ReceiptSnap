import SwiftUI

struct SettingsView: View {
    @AppStorage("useCloudKit") private var useCloudKit = false
    @AppStorage("smartRemindersEnabled") private var smartRemindersEnabled = false
    @AppStorage("reminderFrequency") private var reminderFrequency = "Daily"
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                subscriptionSection
                syncSection
                remindersSection
                aboutSection
                supportSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private var subscriptionSection: some View {
        Section("Subscription") {
            if PurchaseManager.shared.isPremium {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                    Text("Premium Active")
                        .font(.subheadline.bold())
                    Spacer()
                    Text("Active")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.green.opacity(0.2))
                        .foregroundStyle(.green)
                        .clipShape(Capsule())
                }
            } else {
                Button(action: { showPaywall = true }) {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundStyle(.yellow)
                        Text("Upgrade to Premium")
                            .font(.subheadline.bold())
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Button("Restore Purchases") {
                Task {
                    await PurchaseManager.shared.restorePurchases()
                }
            }
        }
    }

    private var syncSection: some View {
        Section("Sync") {
            Toggle("iCloud Sync", isOn: $useCloudKit)
            Text("Sync receipts across all your Apple devices")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var remindersSection: some View {
        Section("Smart Reminders") {
            Toggle("Enable Reminders", isOn: $smartRemindersEnabled)
            if smartRemindersEnabled {
                if !PurchaseManager.shared.isPremium {
                    Button("Upgrade for Smart Reminders") {
                        showPaywall = true
                    }
                    .foregroundStyle(.blue)
                }
                Picker("Frequency", selection: $reminderFrequency) {
                    ForEach(["Daily", "Weekly", "Weekdays Only"], id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
            LabeledContent("Build", value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
        }
    }

    private var supportSection: some View {
        Section("Support & Legal") {
            NavigationLink {
                ContactSupportView()
            } label: {
                Label("Contact Support", systemImage: "envelope")
            }

            Link(destination: URL(string: "https://asunnyboy861.github.io/ReceiptSnap/support.html")!) {
                Label("Support Page", systemImage: "questionmark.circle")
            }

            Link(destination: URL(string: "https://asunnyboy861.github.io/ReceiptSnap/privacy.html")!) {
                Label("Privacy Policy", systemImage: "hand.raised")
            }

            Link(destination: URL(string: "https://asunnyboy861.github.io/ReceiptSnap/terms.html")!) {
                Label("Terms of Use", systemImage: "doc.text")
            }
        }
    }
}
