//
//  CalculationDetailView.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//
import SwiftUI
import ScientificKeypad

struct CalculatorDetailView: View {
    @State private var viewModel: CalculatorViewModel
    @State private var keypad = KeypadCoordinator()

    init(calculator: any EngineeringCalculator) {
        _viewModel = State(initialValue: CalculatorViewModel(calculator: calculator))
    }

    var body: some View {
        Form {
            if viewModel.isSolveForAny {
                Picker("Solve for", selection: $viewModel.solveForKey) {
                    ForEach(viewModel.calculator.fields, id: \.key) { field in
                        Text(field.label).tag(field.key)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Inputs") {
                ForEach(viewModel.calculator.fields, id: \.key) { field in
                    fieldRow(field)
                }
            }

            Section("Result") {
                HStack {
                    Text("Result").font(.headline)
                    Spacer()
                    Text("\(viewModel.resultText) \(viewModel.resultUnit)")
                        .font(.title2.bold())
                }
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
        .navigationTitle(viewModel.calculator.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func fieldRow(_ field: CalculatorField) -> some View {
        let isOutput = field.key == viewModel.solveForKey

        if isOutput {
            VStack(alignment: .leading, spacing: 4) {
                Text(field.unit.isEmpty ? field.label : "\(field.label) (\(field.unit))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(viewModel.resultText)
                    .font(.system(.title3, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray5)))
            }
        } else {
            ScientificNumberField(
                title: field.unit.isEmpty ? field.label : "\(field.label) (\(field.unit))",
                value: Binding(
                    get: { viewModel.values[field.key] },
                    set: { viewModel.values[field.key] = $0 }
                )
            )
        }
    }
}

#Preview {
    NavigationStack {
        CalculatorDetailView(calculator: OhmsLawCalculator())
    }
}
