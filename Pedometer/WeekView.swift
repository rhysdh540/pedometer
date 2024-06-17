//
//  WeekView.swift
//  Pedometer
//
//  Created by Rhys de Haan on 6/17/24.
//

import SwiftUI

struct WeekView : View {
    @State private var healthData: [HealthData] = []
    
    var body: some View {
        NavigationStack {
            List(healthData, id: \.date) { data in
                HStack {
                    Text("\(data.date, formatter: dateFormatter)")
                    Spacer()
                    Text("\(data.steps) steps")
                    Spacer()
                    Text("\(String(format: "%.2f", data.distance / 1000)) km")
                }
            }
            .navigationTitle("Week")
            .navigationBarItems(trailing: Button(action: refresh) {
                Image(systemName: "arrow.clockwise.circle")
            })
            .onAppear(perform: refresh)
        }
    }
    
    private func refresh() {
        let now = Date()
        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: now)!
        HealthKitManager.shared.fetchHealthDataRange(startDate: lastWeek, endDate: now) { data in
            self.healthData = data
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

#Preview {
    ContentView()
}
