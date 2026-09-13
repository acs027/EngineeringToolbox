//
//  CalculationRegistry.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation

/// Single place to register a new calculator. Add a struct conforming to
/// `EngineeringCalculator` above, then list it here — the list view and
/// detail view need no other changes.
enum CalculatorRegistry {
    static let all: [any EngineeringCalculator] = [
        OhmsLawCalculator(),
        ResistorSeriesCalculator(),
        ResistorParallelCalculator(),
        ElectricalPowerCalculator(),
        TorqueCalculator(),
        GearRatioCalculator(),
        PowerTorqueRPMCalculator(),
        BeamDeflectionCalculator(),
        StressCalculator(),
        ReynoldsNumberCalculator(),
        HeatEnergyCalculator(),
        FlowRateCalculator(),
        PipePressureLossCalculator(),
        HeatTransferCalculator(),
        ThermalExpansionCalculator(),
        ToleranceCalculator(),
        SafetyFactorCalculator(),
        CuttingSpeedCalculator(),
        FeedRateCalculator(),
        MachiningTimeCalculator(),
        HydraulicCylinderForceCalculator(),
        OEECalculator()
    ]

    static func calculators(in category: CalculatorCategory) -> [any EngineeringCalculator] {
        all.filter { $0.category == category }
    }
}
