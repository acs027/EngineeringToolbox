//
//  UnitPickerView.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import SwiftUI

/// A labeled Picker for choosing one Dimension unit out of a list.
/// Dimension isn't natively Hashable, so selection is bridged through `symbol` strings.
struct UnitPickerView: View {
    let title: String
    let units: [Dimension]
    @Binding var selection: Dimension

    private var selectedSymbol: Binding<String> {
        Binding(
            get: { selection.symbol },
            set: { newSymbol in
                if let match = units.first(where: { $0.symbol == newSymbol }) {
                    selection = match
                }
            }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker(title, selection: selectedSymbol) {
                ForEach(units, id: \.symbol) { unit in
                    Text(unit.symbol)
                        .tag(unit.symbol)
                        
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
    }
}
