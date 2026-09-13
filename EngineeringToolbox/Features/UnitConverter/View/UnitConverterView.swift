//
//  ConverterView.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation
import SwiftUI
import ScientificKeypad

struct UnitConverterView: View {
    @State private var viewModel = UnitConverterViewModel()
    @State private var keypad = KeypadCoordinator()

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(UnitCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.iconName)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Convert") {
                    ScientificNumberField(
                        title: "Value",
                        value: $viewModel.inputValue
                    )
                    .font(.title2)

                    HStack {
                        UnitPickerView(
                            title: "From",
                            units: viewModel.availableUnits,
                            selection: $viewModel.fromUnit
                        )
                        Spacer()
                        Button {
                            viewModel.swapUnits()
                        } label: {
                            Image(systemName: "arrow.left.arrow.right.circle.fill")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        UnitPickerView(
                            title: "To",
                            units: viewModel.availableUnits,
                            selection: $viewModel.toUnit
                        )
                    }
                }

                Section("Result") {
                    Text(viewModel.resultText)
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.semibold)

                    Text(viewModel.summaryText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .environment(keypad)
            .safeAreaInset(edge: .bottom) {
                if keypad.activeFieldID != nil {
                    CalculatorKeypadBar(coordinator: keypad)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: keypad.activeFieldID)
            .navigationTitle("Unit Converter")
        }
    }
}

#Preview {
    UnitConverterView()
}
