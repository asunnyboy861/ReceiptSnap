import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Query private var receipts: [Receipt]
    @State private var selectedPeriod = "This Month"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    summaryCards
                    categoryBreakdown
                    monthlyTrend
                }
                .padding()
            }
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
            .navigationTitle("Analytics")
        }
    }

    private var filteredReceipts: [Receipt] {
        let calendar = Calendar.current
        let now = Date()
        switch selectedPeriod {
        case "This Week":
            let start = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            return receipts.filter { $0.date >= start }
        case "This Month":
            let start = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            return receipts.filter { $0.date >= start }
        case "This Year":
            let start = calendar.date(from: calendar.dateComponents([.year], from: now))!
            return receipts.filter { $0.date >= start }
        default:
            return receipts
        }
    }

    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCardView(
                title: "Total",
                value: filteredReceipts.reduce(0) { $0 + $1.totalAmount },
                icon: "dollarsign.circle.fill",
                color: .blue
            )
            SummaryCardView(
                title: "Receipts",
                value: Double(filteredReceipts.count),
                icon: "doc.text.fill",
                color: .green
            )
            SummaryCardView(
                title: "Tax",
                value: filteredReceipts.reduce(0) { $0 + $1.taxAmount },
                icon: "percent",
                color: .orange
            )
        }
    }

    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("By Category")
                .font(.headline)

            let categoryData = Dictionary(grouping: filteredReceipts) { $0.category }
                .map { (key, value) in
                    CategoryData(
                        category: key,
                        total: value.reduce(0) { $0 + $1.totalAmount },
                        count: value.count
                    )
                }
                .sorted { $0.total > $1.total }

            if categoryData.isEmpty {
                Text("No data yet")
                    .foregroundStyle(.secondary)
            } else {
                Chart(categoryData) { item in
                    BarMark(
                        x: .value("Amount", item.total),
                        y: .value("Category", item.category)
                    )
                    .foregroundStyle(Color(categoryColor(for: item.category)).gradient)
                    .annotation(position: .trailing) {
                        Text(item.total, format: .currency(code: "USD"))
                            .font(.caption2)
                    }
                }
                .frame(height: CGFloat(categoryData.count) * 36)
                .chartXAxis(.hidden)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var monthlyTrend: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Trend")
                .font(.headline)

            let monthlyData = Dictionary(grouping: filteredReceipts) { receipt in
                Calendar.current.dateComponents([.year, .month], from: receipt.date)
            }
            .compactMap { (components, value) -> MonthlyData? in
                guard let date = Calendar.current.date(from: components) else { return nil }
                return MonthlyData(
                    date: date,
                    total: value.reduce(0) { $0 + $1.totalAmount }
                )
            }
            .sorted { $0.date < $1.date }

            if monthlyData.isEmpty {
                Text("No data yet")
                    .foregroundStyle(.secondary)
            } else {
                Chart(monthlyData) { item in
                    LineMark(
                        x: .value("Month", item.date, unit: .month),
                        y: .value("Total", item.total)
                    )
                    .foregroundStyle(.blue.gradient)
                    .interpolationMethod(.catmullRom)

                    AreaMark(
                        x: .value("Month", item.date, unit: .month),
                        y: .value("Total", item.total)
                    )
                    .foregroundStyle(.blue.opacity(0.1))
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let val = value.as(Double.self) {
                                Text(val, format: .currency(code: "USD").precision(.fractionLength(0)))
                                    .font(.caption2)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func categoryColor(for category: String) -> String {
        ReceiptCategory(rawValue: category)?.color ?? "gray"
    }
}

struct SummaryCardView: View {
    let title: String
    let value: Double
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            if title == "Receipts" {
                Text(value, format: .number)
                    .font(.title3.bold())
            } else {
                Text(value, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .font(.title3.bold())
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CategoryData: Identifiable {
    let id = UUID()
    let category: String
    let total: Double
    let count: Int
}

struct MonthlyData: Identifiable {
    let id = UUID()
    let date: Date
    let total: Double
}
