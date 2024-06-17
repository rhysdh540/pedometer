//
//  StepCountView.swift
//  Pedometer Watch ComplicationsExtension
//
//  Created by Rhys de Haan on 6/17/24.
//

import SwiftUI
import WidgetKit

struct DataDisplayView: View {
    let data: Any
    
    var body: some View {
        Text("\(data)")
            .font(.caption)
            .bold()
            .multilineTextAlignment(.center)
            .containerBackground(for: .widget) {}
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        DataDisplayView(data: "12\n Steps")
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
