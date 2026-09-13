//
//  ElectricalCalculators.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation

/// V = IR, P = VI — classic 4-variable electrical relationship.
/// solveForAny: the user picks which of V/I/R/P to solve for and fills the rest.
struct OhmsLawCalculator: EngineeringCalculator {
    let id = "ohms-law"
    let title = "Ohm's Law"
    let category: CalculatorCategory = .electrical
    let mode: CalculatorMode = .solveForAny
    let fields: [CalculatorField] = [
        CalculatorField(key: "V", label: "Voltage", unit: "V"),
        CalculatorField(key: "I", label: "Current", unit: "A"),
        CalculatorField(key: "R", label: "Resistance", unit: "Ω"),
        CalculatorField(key: "P", label: "Power", unit: "W")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        let v = known["V"], i = known["I"], r = known["R"], p = known["P"]

        switch solveFor {
        case "V":
            if let i, let r { return i * r }
            if let p, let i, i != 0 { return p / i }
            if let p, let r, p * r >= 0 { return (p * r).squareRoot() }
        case "I":
            if let v, let r, r != 0 { return v / r }
            if let p, let v, v != 0 { return p / v }
            if let p, let r, r != 0, p / r >= 0 { return (p / r).squareRoot() }
        case "R":
            if let v, let i, i != 0 { return v / i }
            if let v, let p, p != 0 { return (v * v) / p }
            if let p, let i, i != 0 { return p / (i * i) }
        case "P":
            if let v, let i { return v * i }
            if let v, let r, r != 0 { return (v * v) / r }
            if let i, let r { return (i * i) * r }
        default:
            return nil
        }
        return nil
    }
}

/// Rtotal = R1 + R2
struct ResistorSeriesCalculator: EngineeringCalculator {
    let id = "resistor-series"
    let title = "Resistors in Series"
    let category: CalculatorCategory = .electrical
    let mode: CalculatorMode = .fixedOutput(outputKey: "Rtotal")
    let fields: [CalculatorField] = [
        CalculatorField(key: "R1", label: "R1", unit: "Ω"),
        CalculatorField(key: "R2", label: "R2", unit: "Ω"),
        CalculatorField(key: "Rtotal", label: "Total Resistance", unit: "Ω")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "Rtotal", let r1 = known["R1"], let r2 = known["R2"] else { return nil }
        return r1 + r2
    }
}

/// Rtotal = (R1 * R2) / (R1 + R2)
struct ResistorParallelCalculator: EngineeringCalculator {
    let id = "resistor-parallel"
    let title = "Resistors in Parallel"
    let category: CalculatorCategory = .electrical
    let mode: CalculatorMode = .fixedOutput(outputKey: "Rtotal")
    let fields: [CalculatorField] = [
        CalculatorField(key: "R1", label: "R1", unit: "Ω"),
        CalculatorField(key: "R2", label: "R2", unit: "Ω"),
        CalculatorField(key: "Rtotal", label: "Total Resistance", unit: "Ω")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "Rtotal",
              let r1 = known["R1"], let r2 = known["R2"],
              r1 + r2 != 0 else { return nil }
        return (r1 * r2) / (r1 + r2)
    }
}

/// Three-phase real power: P = √3 · V_line · I_line · PF
struct ElectricalPowerCalculator: EngineeringCalculator {
    let id = "electrical-power"
    let title = "Electrical Power (3-Phase)"
    let category: CalculatorCategory = .electrical
    let mode: CalculatorMode = .fixedOutput(outputKey: "power")
    let fields: [CalculatorField] = [
        CalculatorField(key: "voltage", label: "Line Voltage", unit: "V"),
        CalculatorField(key: "current", label: "Line Current", unit: "A"),
        CalculatorField(key: "powerFactor", label: "Power Factor", unit: ""),
        CalculatorField(key: "power", label: "Real Power", unit: "W")
    ]
 
    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "power",
              let v = known["voltage"], let i = known["current"],
              let pf = known["powerFactor"] else { return nil }
        return 1.7320508075688772 * v * i * pf // √3 · V · I · PF
    }
}
