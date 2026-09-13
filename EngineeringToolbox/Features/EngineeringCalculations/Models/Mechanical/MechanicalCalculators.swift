//
//  MechanicalCalculators.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation

/// τ = F * r
struct TorqueCalculator: EngineeringCalculator {
    let id = "torque"
    let title = "Torque"
    let category: CalculatorCategory = .mechanical
    let mode: CalculatorMode = .fixedOutput(outputKey: "torque")
    let fields: [CalculatorField] = [
        CalculatorField(key: "force", label: "Force", unit: "N"),
        CalculatorField(key: "radius", label: "Lever Arm", unit: "m"),
        CalculatorField(key: "torque", label: "Torque", unit: "N·m")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "torque",
              let force = known["force"], let radius = known["radius"] else { return nil }
        return force * radius
    }
}

/// Gear ratio = driven teeth / driver teeth
struct GearRatioCalculator: EngineeringCalculator {
    let id = "gear-ratio"
    let title = "Gear Ratio"
    let category: CalculatorCategory = .mechanical
    let mode: CalculatorMode = .fixedOutput(outputKey: "ratio")
    let fields: [CalculatorField] = [
        CalculatorField(key: "driverTeeth", label: "Driver Teeth", unit: "teeth"),
        CalculatorField(key: "drivenTeeth", label: "Driven Teeth", unit: "teeth"),
        CalculatorField(key: "ratio", label: "Gear Ratio", unit: ":1")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "ratio",
              let driver = known["driverTeeth"], driver != 0,
              let driven = known["drivenTeeth"] else { return nil }
        return driven / driver
    }
}

/// P = τ · ω, where ω = RPM · (2π/60). Solve for any of Power/Torque/RPM.
struct PowerTorqueRPMCalculator: EngineeringCalculator {
    let id = "power-torque-rpm"
    let title = "Torque / Power / RPM"
    let category: CalculatorCategory = .mechanical
    let mode: CalculatorMode = .solveForAny
    let fields: [CalculatorField] = [
        CalculatorField(key: "power", label: "Power", unit: "W"),
        CalculatorField(key: "torque", label: "Torque", unit: "N·m"),
        CalculatorField(key: "rpm", label: "Speed", unit: "RPM")
    ]
 
    private let angularFactor = 2 * Double.pi / 60 // rad/s per RPM
 
    func compute(known: [String: Double], solveFor: String) -> Double? {
        let power = known["power"], torque = known["torque"], rpm = known["rpm"]
 
        switch solveFor {
        case "power":
            guard let torque, let rpm else { return nil }
            return torque * rpm * angularFactor
        case "torque":
            guard let power, let rpm, rpm != 0 else { return nil }
            return power / (rpm * angularFactor)
        case "rpm":
            guard let power, let torque, torque != 0 else { return nil }
            return power / (torque * angularFactor)
        default:
            return nil
        }
    }
}
