//
//  ContentView.swift
//  EngineeringToolbox
//
//  Created by ali cihan on 7.09.2026.
//

import SwiftUI
import ScientificKeypad

struct ContentView: View {
    @State private var keypad = KeypadCoordinator()
    @State private var length: Double? = nil
    @State private var resistance: Double? = nil
    
    
    var body: some View {
            UnitConverterView()
        ScientificNumberField(title: "Length (m)", value: $length)
            .environment(keypad)
            .safeAreaInset(edge: .bottom) {
                if keypad.activeFieldID != nil {
                    CalculatorKeypadBar(coordinator: keypad)
                        .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: keypad.activeFieldID)
    }
}

#Preview {
    ContentView()
    
}


