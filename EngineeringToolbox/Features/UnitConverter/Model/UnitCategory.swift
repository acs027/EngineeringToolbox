//
//  UnitCategory.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation

/// Every category of unit the app supports.
/// Each case maps to a family of Foundation `Dimension` units, so all the
/// actual conversion math is handled by `Measurement`/`Dimension` for free.
enum UnitCategory: String, CaseIterable, Identifiable {
    case length      = "Length"
    case mass        = "Mass"
    case temperature = "Temperature"
    case volume      = "Volume"
    case area        = "Area"
    case speed       = "Speed"
    case duration    = "Time"
    case energy      = "Energy"
    case pressure    = "Pressure"
    case angle       = "Angle"
    case power       = "Power"
    case frequency   = "Frequency"
    case digitalStorage = "Digital Storage"

    var id: String { rawValue }

    /// SF Symbol used in the category picker.
    var iconName: String {
        switch self {
        case .length:          return "ruler"
        case .mass:            return "scalemass"
        case .temperature:     return "thermometer.medium"
        case .volume:          return "drop"
        case .area:            return "square.dashed"
        case .speed:           return "speedometer"
        case .duration:        return "clock"
        case .energy:          return "bolt"
        case .pressure:        return "gauge.with.dots.needle.50percent"
        case .angle:           return "angle"
        case .power:           return "bolt.fill"
        case .frequency:       return "waveform"
        case .digitalStorage:  return "externaldrive"
        }
    }

    /// All the units available for this category, in a sensible display order.
    /// These are all stock Foundation `Dimension` subclasses.
    var units: [Dimension] {
        switch self {
        case .length:
            return [UnitLength.kilometers, UnitLength.meters, UnitLength.centimeters,
                    UnitLength.millimeters, UnitLength.miles, UnitLength.yards,
                    UnitLength.feet, UnitLength.inches, UnitLength.nauticalMiles]

        case .mass:
            return [UnitMass.metricTons, UnitMass.kilograms, UnitMass.grams,
                    UnitMass.milligrams, UnitMass.pounds, UnitMass.ounces,
                    UnitMass.stones]

        case .temperature:
            return [UnitTemperature.celsius, UnitTemperature.fahrenheit,
                    UnitTemperature.kelvin]

        case .volume:
            return [UnitVolume.liters, UnitVolume.milliliters, UnitVolume.cubicMeters,
                    UnitVolume.gallons, UnitVolume.quarts, UnitVolume.pints,
                    UnitVolume.cups, UnitVolume.fluidOunces, UnitVolume.tablespoons,
                    UnitVolume.teaspoons]

        case .area:
            return [UnitArea.squareKilometers, UnitArea.squareMeters,
                    UnitArea.squareCentimeters, UnitArea.squareMiles,
                    UnitArea.squareYards, UnitArea.squareFeet,
                    UnitArea.squareInches, UnitArea.acres, UnitArea.hectares]

        case .speed:
            return [UnitSpeed.metersPerSecond, UnitSpeed.kilometersPerHour,
                    UnitSpeed.milesPerHour, UnitSpeed.knots]

        case .duration:
            return [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds]

        case .energy:
            return [UnitEnergy.kilojoules, UnitEnergy.joules, UnitEnergy.calories,
                    UnitEnergy.kilocalories, UnitEnergy.kilowattHours]

        case .pressure:
            return [UnitPressure.bars, UnitPressure.millibars, UnitPressure.hectopascals,
                    UnitPressure.kilopascals, UnitPressure.newtonsPerMetersSquared,
                    UnitPressure.poundsForcePerSquareInch, UnitPressure.inchesOfMercury,
                    UnitPressure.millimetersOfMercury]

        case .angle:
            return [UnitAngle.degrees, UnitAngle.arcMinutes, UnitAngle.arcSeconds,
                    UnitAngle.radians, UnitAngle.gradians, UnitAngle.revolutions]

        case .power:
            return [UnitPower.kilowatts, UnitPower.watts, UnitPower.milliwatts,
                    UnitPower.horsepower]

        case .frequency:
            return [UnitFrequency.gigahertz, UnitFrequency.megahertz,
                    UnitFrequency.kilohertz, UnitFrequency.hertz]

        case .digitalStorage:
            return [UnitInformationStorage.terabytes, UnitInformationStorage.gigabytes,
                    UnitInformationStorage.megabytes, UnitInformationStorage.kilobytes,
                    UnitInformationStorage.bytes]
        }
    }
}
