# ReceiptSnap - iOS Development Guide

## Executive Summary

ReceiptSnap is a privacy-first, smart receipt scanner and auto-sync tool designed for freelancers, small business owners, and individuals in the US market. The app solves the "first mile" problem of receipt management: users forgetting to scan receipts, OCR inaccuracy, and the overwhelming complexity of enterprise-grade expense tools.

**Product Vision**: "Snap It. Sync It. Done." - A 3-step receipt management workflow that eliminates friction between purchase and record.

**Target Audience**: US freelancers, sole proprietors, small business owners, and anyone who needs to track expenses for tax deductions without paying enterprise-level subscription fees.

**Key Differentiators**:
1. Smart Reminders - Location-based + habit-based notifications (no competitor offers this)
2. Local OCR - Apple Vision Framework for on-device text recognition (privacy-first)
3. 3-Step Flow - Snap, Confirm, Sync (vs. 5+ steps in competitors)
4. Affordable Pricing - Significantly cheaper than Expensify ($5-9/user/mo) or Dext ($25/mo)
5. iCloud Sync - Native Apple ecosystem integration without third-party cloud dependency

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Expensify | SmartScan OCR 95%+, approval workflows, integrations | Feature overload, $5-9/user/mo, enterprise-focused | Simpler UI, local OCR, lower price, smart reminders |
| SparkReceipt | ChatGPT AI extraction, 150+ currencies, free tier (15/mo) | Cloud-dependent OCR, limited offline, $5.99/mo Pro | Local OCR (privacy), smart reminders, iCloud native |
| Dext | 99%+ OCR accuracy, accountant collaboration | $25/mo, enterprise-only pricing | 10x cheaper, individual-friendly, no accountant needed |
| Zoho Expense | Good free tier, team features | Free limited to 20 scans/mo, complex UI | More generous free tier, simpler UX, smart reminders |
| Veryfi | Highest OCR accuracy (99%+) | API-first, no complete app experience | Full native iOS app, integrated workflow |
| Wave | Completely free | Slow OCR, requires manual correction, limited features | Fast local OCR, smart categorization, reminders |
| QuickBooks | Full accounting suite | $30/mo, receipt scanning is poor, QB-only ecosystem | Receipt-focused, affordable, works standalone |
| SimplyWise | Email auto-import, mileage tracking | Opaque subscription pricing, cloud-only | Transparent pricing, local OCR, smart reminders |

## Apple Design Guidelines Compliance

- **Human Interface Guidelines - Scanning**: Use VNDocumentCameraViewController for native scanning experience with automatic edge detection
- **Privacy**: All OCR processing on-device via Vision Framework; no receipt data sent to third-party servers
- **HIG - Navigation**: Tab-based navigation with clear hierarchy; Settings accessible from profile tab
- **HIG - Data Entry**: Minimal manual input; OCR auto-fills merchant, amount, date, category
- **HIG - Notifications**: Smart reminders use UNUserNotificationCenter with user-controlled frequency
- **HIG - iCloud**: NSPersistentCloudKitContainer for seamless sync across devices
- **Accessibility**: VoiceOver support for all receipt data; Dynamic Type for text sizing
- **Dark Mode**: Full support via SwiftUI semantic colors

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), VisionKit, Vision, PDFKit
- **Data**: SwiftData with CloudKit integration
- **Networking**: URLSession for Google Sheets export
- **Image**: Vision Framework for on-device OCR
- **Notifications**: UserNotifications + CoreLocation for smart reminders
- **Charts**: Swift Charts for expense analytics

## Module Structure

```
ReceiptSnap/
├── ReceiptSnap/
│   ├── ReceiptSnapApp.swift
│   ├── Views/
│   │   ├── Scanner/
│   │   │   └── ScannerView.swift
│   │   ├── Receipts/
│   │   │   ├── ReceiptListView.swift
│   │   │   └── ReceiptDetailView.swift
│   │   ├── Analytics/
│   │   │   └── AnalyticsView.swift
│   │   ├── Settings/
│   │   │   ├── SettingsView.swift
│   │   │   └── ContactSupportView.swift
│   │   └── Components/
│   │       └── ReceiptCardView.swift
│   ├── ViewModels/
│   │   ├── ScannerViewModel.swift
│   │   ├── ReceiptListViewModel.swift
│   │   └── AnalyticsViewModel.swift
│   ├── Models/
│   │   ├── Receipt.swift
│   │   └── ReceiptCategory.swift
│   ├── Services/
│   │   ├── OCRService.swift
│   │   ├── ReceiptParser.swift
│   │   ├── SmartReminderManager.swift
│   │   ├── ExportService.swift
│   │   └── PurchaseManager.swift
│   └── Assets.xcassets/
├── ReceiptSnapTests/
└── ReceiptSnapUITests/
```

## Implementation Flow

1. Create data models (Receipt, ReceiptCategory) with SwiftData
2. Implement VNDocumentCameraViewController wrapper for scanning
3. Build OCR service using Vision Framework (VNRecognizeTextRequest)
4. Create ReceiptParser to extract merchant, total, tax, date, category from OCR text
5. Build receipt list view with search, filter, and sort
6. Build receipt detail view with edit capability
7. Implement smart reminder system (location + habit based)
8. Build analytics view with Swift Charts (spending by category, monthly trends)
9. Implement iCloud sync via NSPersistentCloudKitContainer
10. Add Google Sheets CSV export
11. Implement IAP subscription with StoreKit 2
12. Build Settings view with policy links, contact support, restore purchases
13. Create paywall view for subscription upgrade
14. Generate app icon and configure asset catalog
15. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**: 
  - Primary: #007AFF (iOS Blue) for actions and accents
  - Secondary: #34C759 (Green) for success/verified states
  - Background: System backgrounds (automatic light/dark mode)
  - Category Colors: Distinct colors per receipt category
  
- **Typography**: 
  - SF Pro (system default)
  - Large Title for screen headers
  - Headline for section titles
  - Body for content
  - Caption for metadata (dates, amounts)

- **Layout**:
  - TabView with 4 tabs: Scan, Receipts, Analytics, Settings
  - Scan tab: Large camera button centered, recent receipts below
  - Receipts tab: Search bar + filter chips + card list
  - Analytics tab: Summary cards + charts
  - Settings tab: Grouped list style
  - iPad: Content max width 720pt, centered

- **Animations**:
  - Scan success: Checkmark with scale animation
  - Receipt card: Subtle shadow on tap
  - Tab transitions: Default SwiftUI slide
  - Pull to refresh: Standard iOS refresh control

## Code Generation Rules

- Use SwiftUI exclusively for all views
- Follow MVVM pattern with @Observable ViewModels
- Use SwiftData for persistence
- All OCR processing on-device via Vision Framework
- No third-party dependencies unless absolutely necessary
- Single responsibility per file
- Semantic naming conventions
- No code comments unless explicitly requested

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.ReceiptSnap
2. Verify Deployment Target: iOS 17.0
3. Configure App Icon (1024x1024)
4. Enable capabilities: Camera, Photo Library, Notifications, Location, iCloud
5. Build and test on iPhone XS Max simulator
6. Build and test on iPad Pro 13-inch (M4) simulator
7. Push to GitHub repository
8. Deploy policy pages to GitHub Pages
9. Generate App Store Connect metadata
10. Submit for App Store Review
