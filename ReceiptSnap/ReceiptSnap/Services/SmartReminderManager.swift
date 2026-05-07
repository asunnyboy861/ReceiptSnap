import Foundation
import CoreLocation
import UserNotifications

class SmartReminderManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestPermissions() {
        locationManager.requestAlwaysAuthorization()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func startMonitoring() {
        locationManager.startMonitoringSignificantLocationChanges()
        scheduleDailyReminder()
    }

    func stopMonitoring() {
        locationManager.stopMonitoringSignificantLocationChanges()
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "ReceiptSnap Reminder"
        content.body = "Don't forget to scan your receipts today!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-receipt-reminder", content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to schedule reminder: \(error)")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        checkNearbyStores(location: location)
    }

    private func checkNearbyStores(location: CLLocation) {
        let content = UNMutableNotificationContent()
        content.title = "Scan Your Receipt"
        content.body = "You're near a store. Don't forget to snap your receipt!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "location-reminder-\(UUID().uuidString)", content: content, trigger: trigger)

        notificationCenter.add(request)
    }
}
