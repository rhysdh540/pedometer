//
//  ContentView.swift
//  Pedometer
//
//  Created by Rhys de Haan on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var healthData: [HealthData] = []
    private let healthKitManager = HealthKitManager.shared
    @State private var isAuthorized = HealthKitManager.shared.isAuthorized()

    var body: some View {
        NavigationView {
            VStack {
                if isAuthorized {
                    List(healthData, id: \.date) { data in
                        HStack {
                            Text("\(data.date, formatter: dateFormatter)")
                            Spacer()
                            Text("\(data.steps) steps")
                            Spacer()
                            Text("\(String(format: "%.2f", data.distance / 1000)) km")
                        }
                    }
                    .navigationBarTitle("Health Data")
                    .navigationBarItems(trailing: Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                    })
                    .onAppear {
                        refresh()
                    }
                } else {
                    Text("Please grant HealthKit permissions.")
                    Button("Grant Permissions") {
                        healthKitManager.requestAuthorization { success in
                            if success {
                                self.isAuthorized = true
                                refresh()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    private func refresh() {
        let now = Date()
        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: now)!
        healthKitManager.fetchHealthDataRange(startDate: lastWeek, endDate: now) { data in
            DispatchQueue.main.async {
                self.healthData = data
            }
        }
    }
}


//#Preview {
//    ContentView()
//}
