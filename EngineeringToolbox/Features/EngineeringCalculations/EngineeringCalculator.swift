//
//  EngineeringCalculator.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation

enum CalculatorCategory: String, CaseIterable, Hashable {
    case electrical, mechanical, structural, fluidThermal, manufacturing, materials

    var title: String {
        switch self {
        case .electrical:   return "Electrical"
        case .mechanical:   return "Mechanical"
        case .structural:   return "Structural"
        case .fluidThermal: return "Fluid & Thermal"
        case .manufacturing: return "Manufacturing"
        case .materials: return "Materials"
        }
    }
}

/// One numeric slot in a calculator — either an input the user fills in,
/// or (for `.solveForAny` calculators) a variable that could be the target.
struct CalculatorField: Hashable {
    let key: String
    let label: String
    let unit: String
}

enum CalculatorMode {
    /// Every field except `outputKey` is a user input; `outputKey` is always
    /// the read-only computed result (e.g. Beam Deflection, Stress).
    case fixedOutput(outputKey: String)

    /// All fields are the same kind of variable; the user picks which one
    /// to solve for and fills in the rest (e.g. Ohm's Law).
    case solveForAny
}

protocol EngineeringCalculator: Identifiable {
    var id: String { get }
    var title: String { get }
    var category: CalculatorCategory { get }
    var mode: CalculatorMode { get }
    var fields: [CalculatorField] { get }

    /// Computes the value for `solveFor` given whichever other fields are
    /// known. Return nil if the known values aren't enough to solve it.
    func compute(known: [String: Double], solveFor: String) -> Double?
}
