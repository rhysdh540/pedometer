//
//  ContentView.swift
//  Pedometer
//
//  Created by Rhys de Haan on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthorized = HealthKitManager.shared.isAuthorized()

    var body: some View {
        if isAuthorized {
            TabView {
                DayView()
                    .tabItem {
                        Label("Today", systemImage: "shoeprints.fill")
                    }
                
                WeekView()
                    .tabItem {
                        Label("Week", systemImage: "calendar")
                    }
            }
        } else {
            Text("Please grant HealthKit permissions.")
            Button("Grant Permissions") {
                HealthKitManager.shared.requestAuthorization { success in
                    if success {
                        self.isAuthorized = true
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
