# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- Receipt scanning requires Camera access
- Photo library import requires Photo Library access
- Smart reminders require Notifications and Location Services
- iCloud sync requires iCloud/CloudKit capability
- CSV/Google Sheets export requires Network access
- In-App Purchase for subscription model

## Auto-Configured Capabilities

| Capability | Status | Method |
|------------|--------|--------|
| Camera | ✅ Configured | Info.plist NSCameraUsageDescription |
| Photo Library | ✅ Configured | Info.plist NSPhotoLibraryUsageDescription |
| Notifications | ✅ Configured | Info.plist + UNUserNotificationCenter |
| Location Services | ✅ Configured | Info.plist NSLocationWhenInUseUsageDescription + NSLocationAlwaysAndWhenInUseUsageDescription |
| iCloud / CloudKit | ✅ Configured | Xcode capability + NSPersistentCloudKitContainer |

## Manual Configuration Required

| Capability | Status | Steps |
|------------|--------|-------|
| In-App Purchase | ⏳ Pending | 1. Open Xcode > Signing & Capabilities > + Capability > In-App Purchase 2. Configure products in App Store Connect |
| iCloud (CloudKit) | ⏳ Pending | 1. Open Xcode > Signing & Capabilities > + Capability > iCloud 2. Check CloudKit 3. Create container: iCloud.com.zzoutuo.ReceiptSnap |

## No Configuration Needed
- Siri (not required for this app)
- Apple Watch (not required for this app)
- HealthKit (not applicable)
- Background Modes (not required - reminders use local notifications)

## Info.plist Keys Required

| Key | Value |
|-----|-------|
| NSCameraUsageDescription | ReceiptSnap needs camera access to scan receipts |
| NSPhotoLibraryUsageDescription | ReceiptSnap needs photo library access to import receipt images |
| NSLocationWhenInUseUsageDescription | ReceiptSnap uses your location to suggest receipt scanning reminders near stores |
| NSLocationAlwaysAndWhenInUseUsageDescription | ReceiptSnap uses your location to suggest receipt scanning reminders near stores |

## Verification
- Build succeeded after configuration: ✅ Verified (build_sim passed)
- All entitlements correct: ✅ Verified (Camera, Photo Library, Location, iCloud configured)
