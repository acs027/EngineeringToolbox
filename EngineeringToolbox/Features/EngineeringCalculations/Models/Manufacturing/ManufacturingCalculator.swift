//
//  ManufacturingCalculator.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 9.09.2026.
//

import Foundation

/// Cutting speed: Vc = π · D · N / 1000  (Vc in m/min, D in mm, N in RPM)
/// Solve for any of the three.
struct CuttingSpeedCalculator: EngineeringCalculator {
    let id = "cutting-speed"
    let title = "Cutting Speed / RPM"
    let category: CalculatorCategory = .manufacturing
    let mode: CalculatorMode = .solveForAny
    let fields: [CalculatorField] = [
        CalculatorField(key: "cuttingSpeed", label: "Cutting Speed", unit: "m/min"),
        CalculatorField(key: "diameter", label: "Tool/Work Diameter", unit: "mm"),
        CalculatorField(key: "rpm", label: "Spindle Speed", unit: "RPM")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        let vc = known["cuttingSpeed"], d = known["diameter"], rpm = known["rpm"]

        switch solveFor {
        case "cuttingSpeed":
            if let d, let rpm { return Double.pi * d * rpm / 1000 }
        case "diameter":
            if let vc, let rpm, rpm != 0 { return (1000 * vc) / (Double.pi * rpm) }
        case "rpm":
            if let vc, let d, d != 0 { return (1000 * vc) / (Double.pi * d) }
        default:
            return nil
        }
        return nil
    }
}

/// Feed rate: Vf = N · fz · z  (mm/min = RPM × feed-per-tooth × number of teeth)
struct FeedRateCalculator: EngineeringCalculator {
    let id = "feed-rate"
    let title = "Feed Rate"
    let category: CalculatorCategory = .manufacturing
    let mode: CalculatorMode = .fixedOutput(outputKey: "feedRate")
    let fields: [CalculatorField] = [
        CalculatorField(key: "rpm", label: "Spindle Speed", unit: "RPM"),
        CalculatorField(key: "feedPerTooth", label: "Feed per Tooth", unit: "mm"),
        CalculatorField(key: "teeth", label: "Number of Teeth/Flutes", unit: ""),
        CalculatorField(key: "feedRate", label: "Feed Rate", unit: "mm/min")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "feedRate",
              let rpm = known["rpm"], let fz = known["feedPerTooth"],
              let teeth = known["teeth"] else { return nil }
        return rpm * fz * teeth
    }
}

/// Machining time: Tm = L / Vf
struct MachiningTimeCalculator: EngineeringCalculator {
    let id = "machining-time"
    let title = "Machining Time"
    let category: CalculatorCategory = .manufacturing
    let mode: CalculatorMode = .fixedOutput(outputKey: "time")
    let fields: [CalculatorField] = [
        CalculatorField(key: "length", label: "Cut Length", unit: "mm"),
        CalculatorField(key: "feedRate", label: "Feed Rate", unit: "mm/min"),
        CalculatorField(key: "time", label: "Machining Time", unit: "min")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "time",
              let length = known["length"], let feedRate = known["feedRate"],
              feedRate != 0 else { return nil }
        return length / feedRate
    }
}

/// OEE = Availability × Performance × Quality (each entered as a %, result as a %)
struct OEECalculator: EngineeringCalculator {
    let id = "oee"
    let title = "OEE"
    let category: CalculatorCategory = .manufacturing
    let mode: CalculatorMode = .fixedOutput(outputKey: "oee")
    let fields: [CalculatorField] = [
        CalculatorField(key: "availability", label: "Availability", unit: "%"),
        CalculatorField(key: "performance", label: "Performance", unit: "%"),
        CalculatorField(key: "quality", label: "Quality", unit: "%"),
        CalculatorField(key: "oee", label: "OEE", unit: "%")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "oee",
              let availability = known["availability"],
              let performance = known["performance"],
              let quality = known["quality"] else { return nil }
        return (availability * performance * quality) / 10000
    }
}
