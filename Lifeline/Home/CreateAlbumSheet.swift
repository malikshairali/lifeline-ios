//
//  CreateAlbumSheet.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import SwiftUI

enum DateSelectionType: String, CaseIterable, Identifiable {
    case singleDay = "Single Day"
    case month = "Month"
    case year = "Year"
    case dateRange = "Date Range"
    var id: String { rawValue }
}

struct CreateAlbumSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var albumName = ""
    @State private var selectedType: DateSelectionType = .singleDay

    // date states
    @State private var selectedDate = Date()
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var startDate = Date()
    @State private var endDate = Date()

    var onConfirm: (String, Date, Date) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Album Title")) {
                    TextField("e.g. Summer Trip", text: $albumName)
                }

                Section(header: Text("Date Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(DateSelectionType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                datePickerSection()
            }
            .navigationTitle("Create Album")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Import") {
                        let (start, end) = computeDateRange()
                        onConfirm(albumName, start, end)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    @ViewBuilder
    private func datePickerSection() -> some View {
        switch selectedType {
        case .singleDay:
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
        case .month:
            monthYearPicker()
        case .year:
            yearPicker()
        case .dateRange:
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
        }
    }

    private func monthYearPicker() -> some View {
        HStack {
            Picker("Month", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                }
            }
            Picker("Year", selection: $selectedYear) {
                ForEach((2000...Calendar.current.component(.year, from: Date())).reversed(), id: \.self) {
                    Text("\($0)").tag($0)
                }
            }
        }
    }

    private func yearPicker() -> some View {
        Picker("Year", selection: $selectedYear) {
            ForEach((2000...Calendar.current.component(.year, from: Date())).reversed(), id: \.self) {
                Text("\($0)").tag($0)
            }
        }
    }

    private func computeDateRange() -> (Date, Date) {
        let calendar = Calendar.current
        switch selectedType {
        case .singleDay:
            let start = calendar.startOfDay(for: selectedDate)
            let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDate)!
            return (start, end)
        case .month:
            let comps = DateComponents(year: selectedYear, month: selectedMonth)
            let start = calendar.date(from: comps)!
            let end = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: start)!
                .addingTimeInterval(86399)
            return (start, end)
        case .year:
            let start = calendar.date(from: DateComponents(year: selectedYear, month: 1, day: 1))!
            let end = calendar.date(from: DateComponents(year: selectedYear, month: 12, day: 31))!
                .addingTimeInterval(86399)
            return (start, end)
        case .dateRange:
            let start = calendar.startOfDay(for: startDate)
            let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!
            return (start, end)
        }
    }
}
