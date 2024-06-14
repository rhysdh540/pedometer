//
//  ContentView.swift
//  Pedometer Watch App
//
//  Created by Rhys de Haan on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var steps: Int = 0
    @State private var distance: Double = 0
    @State private var isAuthorized = HealthKitManager.shared.isAuthorized()
    
    var body: some View {
        NavigationStack {
            VStack {
                if isAuthorized {
                    Text("Steps: \(steps)")
                    Text(String(format: "Distance: %.2f km", distance / 1000))
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
                    Button(action: {
                        loadData()
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                }
            }
            .navigationTitle("Steps")
        }
    }
    
    private func loadData() {
        HealthKitManager.shared.fetchTodayData { steps, distance in
            DispatchQueue.main.async {
                self.steps = steps
                self.distance = distance
            }
        }
    }
}

#Preview {
    ContentView()
}
