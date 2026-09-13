//
//  UnitConverterViewModel.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 8.09.2026.
//

import Foundation

/// The single source of truth for the converter screen.
/// The View reads/writes these @Published properties and never touches
/// Measurement/Dimension math directly — that logic lives here.
@Observable
final class UnitConverterViewModel {

    // MARK: - Published state

    var category: UnitCategory = .length {
        didSet { resetUnitsForNewCategory() }
    }

    var inputText: String {
        "\(inputValue, default: "1")"
    }
    var fromUnit: Dimension
    var toUnit: Dimension
    var inputValue: Double?

    // MARK: - Init

    init() {
        let startingUnits = UnitCategory.length.units
        self.fromUnit = startingUnits[0]
        self.toUnit = startingUnits[1]
    }

    // MARK: - Derived data for the View

    /// The list of units the "from"/"to" pickers should show right now.
    var availableUnits: [Dimension] {
        category.units
    }

    /// The formatted result string, e.g. "3.281".
    var resultText: String {
        guard let value = Double(inputText.replacingOccurrences(of: ",", with: ".")) else {
            return "—"
        }
        let converted = Measurement(value: value, unit: fromUnit).converted(to: toUnit)
        return Self.numberFormatter.string(from: NSNumber(value: converted.value))
            ?? String(converted.value)
    }

    /// A one-line summary, e.g. "1 km = 0.621 mi".
    var summaryText: String {
        let input = inputText.isEmpty ? "0" : inputText
        return "\(input) \(fromUnit.symbol) = \(resultText) \(toUnit.symbol)"
    }

    // MARK: - Intents (actions the View can trigger)

    func swapUnits() {
        (fromUnit, toUnit) = (toUnit, fromUnit)
    }

    /// Looks up a unit in the current category by its `symbol`.
    /// Used by the View's picker bindings, since `Dimension` isn't natively Hashable.
    func unit(forSymbol symbol: String) -> Dimension? {
        availableUnits.first { $0.symbol == symbol }
    }

    // MARK: - Private helpers

    private func resetUnitsForNewCategory() {
        let units = category.units
        fromUnit = units[0]
        toUnit = units.count > 1 ? units[1] : units[0]
    }

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = true
        return formatter
    }()
}
