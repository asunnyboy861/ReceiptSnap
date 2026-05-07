# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | ReceiptSnap |
| **Git URL** | git@github.com:asunnyboy861/ReceiptSnap.git |
| **Repo URL** | https://github.com/asunnyboy861/ReceiptSnap |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ENABLED (from /docs folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/ReceiptSnap/ | Active |
| Support | https://asunnyboy861.github.io/ReceiptSnap/support.html | Active |
| Privacy Policy | https://asunnyboy861.github.io/ReceiptSnap/privacy.html | Active |
| Terms of Use | https://asunnyboy861.github.io/ReceiptSnap/terms.html | Active (REQUIRED for subscription) |

**Note**: Terms of Use is REQUIRED for subscription apps per Apple App Store Review Guidelines.

## Repository Structure

```
ReceiptSnap/
├── ReceiptSnap/                   # iOS App Source Code
│   ├── ReceiptSnap.xcodeproj/     # Xcode Project
│   ├── ReceiptSnap/               # Swift Source Files
│   │   ├── Views/
│   │   │   ├── Scanner/
│   │   │   ├── Receipts/
│   │   │   ├── Analytics/
│   │   │   ├── Settings/
│   │   │   └── Components/
│   │   ├── Models/
│   │   └── Services/
│   └── ...
├── docs/                         # Policy Pages (GitHub Pages source)
│   ├── index.html               # Landing Page
│   ├── support.html             # Support Page
│   ├── privacy.html             # Privacy Policy
│   └── terms.html               # Terms of Use (subscription required)
├── .github/workflows/
│   └── deploy.yml               # GitHub Pages deployment
├── us.md                         # English Development Guide
├── keytext.md                    # App Store Metadata
├── capabilities.md               # Capabilities Configuration
├── icon.md                       # App Icon Details
├── price.md                      # Pricing Configuration
└── nowgit.md                     # This File
```
