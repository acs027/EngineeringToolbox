//
//  StructuralCalculators.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation

/// Simply supported beam, center point load: δ = F·L³ / (48·E·I)
struct BeamDeflectionCalculator: EngineeringCalculator {
    let id = "beam-deflection"
    let title = "Beam Deflection (center load)"
    let category: CalculatorCategory = .structural
    let mode: CalculatorMode = .fixedOutput(outputKey: "deflection")
    let fields: [CalculatorField] = [
        CalculatorField(key: "force", label: "Load Force", unit: "N"),
        CalculatorField(key: "length", label: "Span Length", unit: "m"),
        CalculatorField(key: "modulus", label: "Elastic Modulus (E)", unit: "Pa"),
        CalculatorField(key: "inertia", label: "Moment of Inertia (I)", unit: "m⁴"),
        CalculatorField(key: "deflection", label: "Max Deflection", unit: "m")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "deflection",
              let f = known["force"], let l = known["length"],
              let e = known["modulus"], let i = known["inertia"],
              e * i != 0 else { return nil }
        return (f * pow(l, 3)) / (48 * e * i)
    }
}

/// σ = F / A
struct StressCalculator: EngineeringCalculator {
    let id = "axial-stress"
    let title = "Axial Stress"
    let category: CalculatorCategory = .structural
    let mode: CalculatorMode = .fixedOutput(outputKey: "stress")
    let fields: [CalculatorField] = [
        CalculatorField(key: "force", label: "Force", unit: "N"),
        CalculatorField(key: "area", label: "Cross-Sectional Area", unit: "m²"),
        CalculatorField(key: "stress", label: "Stress", unit: "Pa")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "stress",
              let force = known["force"], let area = known["area"], area != 0 else { return nil }
        return force / area
    }
}
