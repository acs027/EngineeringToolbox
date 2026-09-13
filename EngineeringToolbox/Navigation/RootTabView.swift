//
//  RootTabView.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 9.09.2026.
//
import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            UnitConverterView()
                .tabItem { Label("Convert", systemImage: "arrow.left.arrow.right") }

            CalculatorListView()
                .tabItem { Label("Calculators", systemImage: "function") }
        }
    }
}

#Preview {
    RootTabView()
}
