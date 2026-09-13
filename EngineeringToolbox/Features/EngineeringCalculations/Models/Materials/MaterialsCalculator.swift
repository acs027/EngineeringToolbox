//
//  MaterialsCalculator.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 9.09.2026.
//

import Foundation

/// Tolerance = Nominal Size × (% Tolerance / 100)
struct ToleranceCalculator: EngineeringCalculator {
    let id = "tolerance"
    let title = "Dimensional Tolerance"
    let category: CalculatorCategory = .materials
    let mode: CalculatorMode = .fixedOutput(outputKey: "tolerance")
    let fields: [CalculatorField] = [
        CalculatorField(key: "nominal", label: "Nominal Size", unit: "mm"),
        CalculatorField(key: "percent", label: "Tolerance", unit: "%"),
        CalculatorField(key: "tolerance", label: "Tolerance Value (±)", unit: "mm")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "tolerance",
              let nominal = known["nominal"], let percent = known["percent"] else { return nil }
        return nominal * (percent / 100)
    }
}

/// Factor of Safety = Failure Stress / Working (Allowable) Stress.
/// Solve for any of the three.
struct SafetyFactorCalculator: EngineeringCalculator {
    let id = "safety-factor"
    let title = "Factor of Safety"
    let category: CalculatorCategory = .materials
    let mode: CalculatorMode = .solveForAny
    let fields: [CalculatorField] = [
        CalculatorField(key: "safetyFactor", label: "Safety Factor", unit: ""),
        CalculatorField(key: "failureStress", label: "Failure / Yield Stress", unit: "Pa"),
        CalculatorField(key: "workingStress", label: "Working (Allowable) Stress", unit: "Pa")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        let sf = known["safetyFactor"], failure = known["failureStress"], working = known["workingStress"]

        switch solveFor {
        case "safetyFactor":
            if let failure, let working, working != 0 { return failure / working }
        case "failureStress":
            if let sf, let working { return sf * working }
        case "workingStress":
            if let failure, let sf, sf != 0 { return failure / sf }
        default:
            return nil
        }
        return nil
    }
}
