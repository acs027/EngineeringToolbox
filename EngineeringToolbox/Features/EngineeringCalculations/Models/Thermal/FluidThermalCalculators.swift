//
//  FluidThermalCalculators.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation

/// Re = (ρ · v · D) / μ
struct ReynoldsNumberCalculator: EngineeringCalculator {
    let id = "reynolds-number"
    let title = "Reynolds Number"
    let category: CalculatorCategory = .fluidThermal
    let mode: CalculatorMode = .fixedOutput(outputKey: "reynolds")
    let fields: [CalculatorField] = [
        CalculatorField(key: "density", label: "Fluid Density (ρ)", unit: "kg/m³"),
        CalculatorField(key: "velocity", label: "Flow Velocity", unit: "m/s"),
        CalculatorField(key: "diameter", label: "Pipe Diameter", unit: "m"),
        CalculatorField(key: "viscosity", label: "Dynamic Viscosity (μ)", unit: "Pa·s"),
        CalculatorField(key: "reynolds", label: "Reynolds Number", unit: "")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "reynolds",
              let rho = known["density"], let v = known["velocity"],
              let d = known["diameter"], let mu = known["viscosity"],
              mu != 0 else { return nil }
        return (rho * v * d) / mu
    }
}

/// Q = m · c · ΔT — solve for any of the four.
struct HeatEnergyCalculator: EngineeringCalculator {
    let id = "heat-energy"
    let title = "Sensible Heat (Q = mcΔT)"
    let category: CalculatorCategory = .fluidThermal
    let mode: CalculatorMode = .solveForAny
    let fields: [CalculatorField] = [
        CalculatorField(key: "Q", label: "Heat Energy", unit: "J"),
        CalculatorField(key: "m", label: "Mass", unit: "kg"),
        CalculatorField(key: "c", label: "Specific Heat", unit: "J/(kg·K)"),
        CalculatorField(key: "dT", label: "Temp. Change (ΔT)", unit: "K")
    ]

    func compute(known: [String: Double], solveFor: String) -> Double? {
        let q = known["Q"], m = known["m"], c = known["c"], dT = known["dT"]

        switch solveFor {
        case "Q":
            if let m, let c, let dT { return m * c * dT }
        case "m":
            if let q, let c, let dT, c * dT != 0 { return q / (c * dT) }
        case "c":
            if let q, let m, let dT, m * dT != 0 { return q / (m * dT) }
        case "dT":
            if let q, let m, let c, m * c != 0 { return q / (m * c) }
        default:
            return nil
        }
        return nil
    }
}


/// Q = A · v — volumetric flow rate. Solve for any of the three.
struct FlowRateCalculator: EngineeringCalculator {
    let id = "flow-rate"
    let title = "Flow Rate"
    let category: CalculatorCategory = .fluidThermal
    let mode: CalculatorMode = .solveForAny
    let fields: [CalculatorField] = [
        CalculatorField(key: "flowRate", label: "Flow Rate", unit: "m³/s"),
        CalculatorField(key: "area", label: "Cross-Sectional Area", unit: "m²"),
        CalculatorField(key: "velocity", label: "Velocity", unit: "m/s")
    ]
 
    func compute(known: [String: Double], solveFor: String) -> Double? {
        let q = known["flowRate"], a = known["area"], v = known["velocity"]
 
        switch solveFor {
        case "flowRate":
            if let a, let v { return a * v }
        case "area":
            if let q, let v, v != 0 { return q / v }
        case "velocity":
            if let q, let a, a != 0 { return q / a }
        default:
            return nil
        }
        return nil
    }
}
 
/// Darcy-Weisbach pressure loss: ΔP = f · (L/D) · (ρ·v²/2)
struct PipePressureLossCalculator: EngineeringCalculator {
    let id = "pipe-pressure-loss"
    let title = "Pipe Pressure Loss"
    let category: CalculatorCategory = .fluidThermal
    let mode: CalculatorMode = .fixedOutput(outputKey: "pressureLoss")
    let fields: [CalculatorField] = [
        CalculatorField(key: "frictionFactor", label: "Friction Factor (f)", unit: ""),
        CalculatorField(key: "length", label: "Pipe Length (L)", unit: "m"),
        CalculatorField(key: "diameter", label: "Pipe Diameter (D)", unit: "m"),
        CalculatorField(key: "density", label: "Fluid Density (ρ)", unit: "kg/m³"),
        CalculatorField(key: "velocity", label: "Flow Velocity", unit: "m/s"),
        CalculatorField(key: "pressureLoss", label: "Pressure Loss (ΔP)", unit: "Pa")
    ]
 
    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "pressureLoss",
              let f = known["frictionFactor"], let l = known["length"],
              let d = known["diameter"], d != 0,
              let rho = known["density"], let v = known["velocity"] else { return nil }
        return f * (l / d) * (rho * v * v / 2)
    }
}
 
/// Steady-state heat transfer rate: Q̇ = U · A · ΔT
struct HeatTransferCalculator: EngineeringCalculator {
    let id = "heat-transfer"
    let title = "Heat Transfer Rate"
    let category: CalculatorCategory = .fluidThermal
    let mode: CalculatorMode = .fixedOutput(outputKey: "heatRate")
    let fields: [CalculatorField] = [
        CalculatorField(key: "coefficient", label: "Heat Transfer Coeff. (U)", unit: "W/(m²·K)"),
        CalculatorField(key: "area", label: "Surface Area", unit: "m²"),
        CalculatorField(key: "deltaT", label: "Temp. Difference (ΔT)", unit: "K"),
        CalculatorField(key: "heatRate", label: "Heat Transfer Rate", unit: "W")
    ]
 
    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "heatRate",
              let u = known["coefficient"], let area = known["area"],
              let dT = known["deltaT"] else { return nil }
        return u * area * dT
    }
}
 
/// Linear thermal expansion: ΔL = α · L₀ · ΔT
struct ThermalExpansionCalculator: EngineeringCalculator {
    let id = "thermal-expansion"
    let title = "Thermal Expansion"
    let category: CalculatorCategory = .fluidThermal
    let mode: CalculatorMode = .fixedOutput(outputKey: "deltaL")
    let fields: [CalculatorField] = [
        CalculatorField(key: "alpha", label: "Expansion Coeff. (α)", unit: "1/K"),
        CalculatorField(key: "length0", label: "Original Length (L₀)", unit: "m"),
        CalculatorField(key: "deltaT", label: "Temp. Change (ΔT)", unit: "K"),
        CalculatorField(key: "deltaL", label: "Length Change (ΔL)", unit: "m")
    ]
 
    func compute(known: [String: Double], solveFor: String) -> Double? {
        guard solveFor == "deltaL",
              let alpha = known["alpha"], let l0 = known["length0"],
              let dT = known["deltaT"] else { return nil }
        return alpha * l0 * dT
    }
}
