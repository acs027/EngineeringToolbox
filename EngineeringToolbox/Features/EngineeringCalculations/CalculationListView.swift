//
//  CalculationListView.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import SwiftUI

struct CalculatorListView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(CalculatorCategory.allCases, id: \.self) { category in
                    let calculators = CalculatorRegistry.calculators(in: category)
                    if !calculators.isEmpty {
                        Section(category.title) {
                            ForEach(calculators, id: \.id) { calculator in
                                NavigationLink(calculator.title) {
                                    CalculatorDetailView(calculator: calculator)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Calculators")
        }
    }
}

#Preview {
    CalculatorListView()
}
