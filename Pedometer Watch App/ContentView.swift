//
//  ContentView.swift
//  Pedometer Watch App
//
//  Created by Rhys de Haan on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var data: HealthData = HealthData(date: Date(), steps: 0, distance: 0)
    @State private var isAuthorized = HealthKitManager.shared.isAuthorized()
    
    var body: some View {
        NavigationStack {
            VStack {
                if isAuthorized {
                    Text("Steps: \(data.steps)")
                    Text(String(format: "Distance: %.2f km", data.distance / 1000))
                        .onAppear {
                            loadData()
                        }
                } else {
                    Text("Please grant HealthKit permissions.")
                    Button("Grant Permissions") {
                        HealthKitManager.shared.requestAuthorization { success in
                            if success {
                                self.isAuthorized = true
                                loadData()
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: loadData) {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                }
            }
            .navigationTitle("Steps")
        }
    }
    
    private func loadData() {
        HealthKitManager.shared.fetchHealthData(for: Date()) { data in
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
