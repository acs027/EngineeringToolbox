//
//  EngineeringCalculationViewModel.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//
import Foundation
import Observation

@Observable
final class CalculatorViewModel {
    let calculator: any EngineeringCalculator
    var values: [String: Double] = [:]
    var solveForKey: String

    init(calculator: any EngineeringCalculator) {
        self.calculator = calculator

        switch calculator.mode {
        case .fixedOutput(let outputKey):
            self.solveForKey = outputKey
        case .solveForAny:
            self.solveForKey = calculator.fields.first?.key ?? ""
        }
    }

    /// Whether this calculator lets the user choose which field to solve for.
    var isSolveForAny: Bool {
        if case .solveForAny = calculator.mode { return true }
        return false
    }

    var result: Double? {
        var known: [String: Double] = [:]
        for field in calculator.fields where field.key != solveForKey {
            if let value = values[field.key] {
                known[field.key] = value
            }
        }
        return calculator.compute(known: known, solveFor: solveForKey)
    }

    var resultText: String {
        guard let result else { return "—" }
        return Self.formatter.string(from: NSNumber(value: result)) ?? String(result)
    }

    var resultUnit: String {
        calculator.fields.first { $0.key == solveForKey }?.unit ?? ""
    }

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.usesGroupingSeparator = true
        return formatter
    }()
}
