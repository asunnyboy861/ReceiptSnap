# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: ReceiptSnap Premium
- **Group ID**: Auto-generated in App Store Connect

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Premium
- **Product ID**: `com.zzoutuo.ReceiptSnap.monthly`
- **Price**: $2.99 per month
- **Display Name**: ReceiptSnap Premium Monthly
- **Description**: Unlimited scans, smart reminders, and analytics
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Premium
- **Product ID**: `com.zzoutuo.ReceiptSnap.yearly`
- **Price**: $19.99 per year (44% savings vs monthly)
- **Display Name**: ReceiptSnap Premium Yearly
- **Description**: Unlimited scans, smart reminders, and analytics
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.ReceiptSnap.lifetime`
- **Price**: $49.99 one-time
- **Display Name**: ReceiptSnap Lifetime
- **Description**: One-time purchase, forever access to all features
- **Note**: Available since no ongoing server/API costs for local OCR

## Free Tier Limits
- **Scans per month**: 10 receipt scans
- **Smart reminders**: Not available
- **Analytics**: Basic view only
- **Export**: CSV only (no Google Sheets)
- **iCloud sync**: Not available

## Premium Features (Unlocked by Subscription)
- **Unlimited scans**: No monthly limit
- **Smart reminders**: Location-based + habit-based notifications
- **Full analytics**: Category breakdown, monthly trends, charts
- **All export formats**: CSV, PDF, Google Sheets
- **iCloud sync**: Sync across all Apple devices
- **Priority support**: Faster response times

## Free Trial
- **Duration**: 7 days
- **Type**: Introductory offer (auto-converts to paid subscription)
- **Applies to**: Monthly and Yearly subscriptions

## Policy Pages Required
- Support Page: Required (Must include subscription management info)
- Privacy Policy: Required
- Terms of Use: Required (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [x] Auto-renewal terms included in Terms
- [x] Cancellation instructions included
- [x] Pricing clearly stated
- [x] Free trial terms included
- [x] Restore purchases functionality implemented

## Competitive Pricing Comparison

| App | Free Tier | Monthly | Yearly | Lifetime |
|-----|-----------|---------|--------|----------|
| ReceiptSnap | 10 scans/mo | $2.99 | $19.99 | $49.99 |
| SparkReceipt | 15 scans/mo | $5.99 | - | - |
| Expensify | Limited | $5-9/user | - | - |
| Zoho Expense | 20 scans/mo | $4/user | - | - |
| Dext | None | $25 | - | - |

ReceiptSnap is the most affordable option with local OCR privacy advantage.
