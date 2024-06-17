//
//  DayView.swift
//  Pedometer
//
//  Created by Rhys de Haan on 6/17/24.
//

import SwiftUI

struct DayView : View {
    @State private var data = HealthData()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("\(data.steps)")
                    .font(.system(size: 75, weight: .bold, design: .rounded))
                    .padding()
                Text("Steps")
                    .font(.title)
                    .padding()
                Spacer()
                Text("Distance: \(String(format: "%.2f", data.distance / 1000)) km")
                    .font(.title2)
                    .padding()
            }
            .navigationTitle("Today")
            .navigationBarItems(trailing: Button(action: refresh) {
                Image(systemName: "arrow.clockwise.circle")
            })
            .onAppear(perform: refresh)
        }
    }
    
    private func refresh() {
        HealthKitManager.shared.fetchHealthData(for: Date()) { data in
            self.data = data
        }
    }
}

#Preview {
    ContentView()
}
