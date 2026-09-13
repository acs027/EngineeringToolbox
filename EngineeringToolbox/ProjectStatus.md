# EngineeringToolbox — Project Status

> **Last Updated:** September 9, 2026  
> **Platform:** iOS 17.0+  
> **Architecture:** Feature-Driven MVVM with SwiftUI & Swift Observation (`@Observable`)  
> **Xcode Project Format:** File System Synchronized Root Group (`PBXFileSystemSynchronizedRootGroup`)

---

## 1. Project Overview

**EngineeringToolbox** is an iOS utility application designed for engineering students and professionals. It provides quick access to unit conversions across multiple physical dimensions and specialized multi-discipline engineering calculators spanning 6 core disciplines: Electrical, Mechanical, Structural, Fluid & Thermal, Manufacturing, and Materials (21 calculators total).

---

## 2. Tech Stack & Dependencies

- **Language:** Swift 5.9+ (Swift 6 compatible)
- **UI Framework:** SwiftUI
- **State Management:** Swift Observation Framework (`@Observable`)
- **System Frameworks:** Foundation (`Measurement`, `Dimension`, `UnitLength`, `UnitMass`, etc.)
- **External Dependencies (SPM):**
  - **`ScientificKeypad`**: Custom scientific input accessory bar (`ScientificNumberField`, `CalculatorKeypadBar`, `KeypadCoordinator`).

---

## 3. Directory & File Structure

```text
EngineeringToolbox/
├── EngineeringToolbox.xcodeproj          # Xcode project configuration
│
└── EngineeringToolbox/                   # Synchronized Root Group
    ├── ProjectStatus.md                  # Project state tracking & documentation (this file)
    ├── Todo.md                           # Planned feature roadmap and future vertical packs
    │
    ├── App/
    │   ├── EngineeringToolboxApp.swift   # App entry point (@main)
    │   └── Assets.xcassets/              # App icon & color sets
    │
    ├── Navigation/
    │   └── RootTabView.swift             # Root TabView (Convert & Calculators tabs)
    │
    ├── ContentView.swift                 # Root host view containing RootTabView
    │
    ├── Features/
    │   ├── UnitConverter/                # Unit Conversion Module
    │   │   ├── Model/
    │   │   │   └── UnitCategory.swift    # 13 physical dimensions & Foundation unit mappings
    │   │   ├── View/
    │   │   │   ├── UnitConverterView.swift  # Main converter screen
    │   │   │   └── UnitPickerView.swift     # Dimension selection picker
    │   │   └── ViewModel/
    │   │       └── UnitConverterViewModel.swift # Converter business logic & formatting
    │   │
    │   └── EngineeringCalculations/      # Engineering Formula Calculators
    │       ├── EngineeringCalculator.swift         # Core protocol, field models, & solve modes
    │       ├── CalculationRegistry.swift           # Central catalog of all 21 calculators
    │       ├── EngineeringCalculationViewModel.swift # Generic dynamic calculation ViewModel
    │       ├── CalculationListView.swift           # Categorized calculator directory view
    │       ├── CalculationDetailView.swift         # Interactive calculator form & keypad integration
    │       └── Models/                             # Calculator formula implementations by discipline
    │           ├── Electrical/
    │           │   └── ElectricalCalculators.swift # Ohm's Law, Resistors, 3-Phase Power
    │           ├── Mechanical/
    │           │   └── MechanicalCalculators.swift # Torque, Gear Ratio, Power/Torque/RPM
    │           ├── Structural/
    │           │   └── StructuralCalculators.swift # Beam Deflection, Axial Stress
    │           ├── Thermal/
    │           │   └── FluidThermalCalculators.swift # Reynolds, Heat, Flow, Pressure Loss, etc.
    │           ├── Manufacturing/
    │           │   └── ManufacturingCalculator.swift # Cutting Speed, Feed Rate, Time, OEE
    │           └── Materials/
    │               └── MaterialsCalculator.swift   # Dimensional Tolerance, Factor of Safety
    │
    └── Shared/
        └── Components/                   # Reusable cross-feature UI components (reserved)
```

---

## 4. Current Features & Capabilities

### A. Navigation
- **`RootTabView`**: Bottom tab navigation separating core capabilities:
  - **Convert Tab**: Direct access to `UnitConverterView`.
  - **Calculators Tab**: Categorized directory via `CalculatorListView`.

### B. Unit Converter (`Features/UnitConverter`)
- **13 Dimension Categories**: Length, Mass, Temperature, Volume, Area, Speed, Time, Energy, Pressure, Angle, Power, Frequency, Digital Storage.
- **Foundation-Powered**: Relies on Apple's `Measurement` and `Dimension` system for precision and correctness.
- **Interactive UI**:
  - Two-way unit swapping button (`swapUnits()`).
  - SF Symbol iconography per category.
  - Scientific keypad integration with decimal formatting.
  - Live preview summary text (e.g. `1 km = 0.621 mi`).

### C. Engineering Calculations Engine (`Features/EngineeringCalculations`)
- **Extensible Architecture**:
  - `EngineeringCalculator` protocol allows plugging new formulas into the app simply by defining a struct and adding it to `CalculationRegistry`.
  - **Two Calculation Modes**:
    1. `.solveForAny`: User selects any variable to solve for; inputs the remaining knowns.
    2. `.fixedOutput(outputKey)`: Dedicated input fields computing a predetermined result.
- **21 Available Calculators Across 6 Disciplines**:
  - **Electrical (4)**:
    - *Ohm's Law* ($V = IR$, $P = VI$) — Solve for any of $V, I, R, P$.
    - *Series Resistors* ($R_{total} = R_1 + R_2 + R_3$).
    - *Parallel Resistors* ($1/R_{total} = 1/R_1 + 1/R_2$).
    - *Electrical Power (3-Phase)* ($P = \sqrt{3} \cdot V_{line} \cdot I_{line} \cdot PF$).
  - **Mechanical (3)**:
    - *Torque* ($\tau = F \times r$) — Solve for any of $\tau, F, r$.
    - *Gear Ratio* ($Ratio = N_{driven} / N_{driver}$).
    - *Torque / Power / RPM* ($P = \tau \cdot \omega$) — Solve for any of $P, \tau, RPM$.
  - **Structural (2)**:
    - *Cantilever Beam Deflection* ($\delta = \frac{F \cdot L^3}{3 \cdot E \cdot I}$).
    - *Axial Stress* ($\sigma = F / A$) — Solve for any of $\sigma, F, A$.
  - **Fluid & Thermal (6)**:
    - *Reynolds Number* ($Re = \frac{\rho \cdot v \cdot D}{\mu}$).
    - *Sensible Heat Energy* ($Q = m \cdot c \cdot \Delta T$).
    - *Flow Rate* ($Q = A \cdot v$) — Solve for any of $Q, A, v$.
    - *Pipe Pressure Loss* (Darcy-Weisbach: $\Delta P = f \cdot \frac{L}{D} \cdot \frac{\rho \cdot v^2}{2}$).
    - *Heat Transfer Rate* ($\dot{Q} = U \cdot A \cdot \Delta T$).
    - *Thermal Expansion* ($\Delta L = \alpha \cdot L_0 \cdot \Delta T$).
    - [x] Hydraulic Cylinder Force (`fluidThermal`) — calculates hydraulic cylinder push force from pressure (bar) and bore diameter (mm), returning kN. Includes input and finite-result validation.
  - **Manufacturing (4)**:
    - *Cutting Speed / RPM* ($V_c = \frac{\pi \cdot D \cdot N}{1000}$) — Solve for any of $V_c, D, N$.
    - *Feed Rate* ($V_f = N \cdot f_z \cdot z$).
    - *Machining Time* ($T_m = L / V_f$).
    - *Overall Equipment Effectiveness (OEE)* ($OEE = Availability \times Performance \times Quality$).
  - **Materials (2)**:
    - *Dimensional Tolerance* ($Tolerance = Nominal \times \frac{\%}{100}$).
    - *Factor of Safety* ($FOS = \frac{Failure}{Working}$) — Solve for any of $FOS, Failure, Working$.

---

## 5. Maintenance & Backlog Notes

- [ ] **Type & File Name Alignment**:
  - `UnitConverterViewModel.swift` declares `class ConverterViewModel` $\rightarrow$ Align to `UnitConverterViewModel`.
  - `CalculationDetailView.swift` declares `struct CalculatorDetailView` $\rightarrow$ Align to match file name.
  - `CalculationListView.swift` declares `struct CalculatorListView` $\rightarrow$ Align to match file name.
  - `EngineeringCalculationViewModel.swift` declares `class CalculatorViewModel` $\rightarrow$ Align to match file name.
- [ ] **Folder Pluralization**:
  - `UnitConverter` uses singular folder names (`Model`, `View`, `ViewModel`), whereas `EngineeringCalculations` uses `Models/`. Consider standardizing to plural (`Models`, `Views`, `ViewModels`).
- [ ] **Direct Double Derivation**:
  - Simplify `UnitConverterViewModel` result calculation directly off `inputValue: Double?` rather than roundtripping through `inputText: String`.
- [ ] **Direct Root View**:
  - `ContentView.swift` only forwards to `RootTabView()`. Consider setting `RootTabView()` directly in `EngineeringToolboxApp.swift`.

---

## 6. Change Log

### [2026-09-09 — Expansion to 21 Calculators]
- Expanded engineering calculators from 9 to 21 across 6 disciplines.
- **Added `Manufacturing` category** with 4 calculators: Cutting Speed / RPM, Feed Rate, Machining Time, and OEE (`ManufacturingCalculator.swift`).
- **Added `Materials` category** with 2 calculators: Dimensional Tolerance and Factor of Safety (`MaterialsCalculator.swift`).
- **Enhanced `Electrical`**: Added 3-Phase Electrical Power ($P = \sqrt{3} \cdot V \cdot I \cdot PF$).
- **Enhanced `Mechanical`**: Added Torque / Power / RPM relationship calculator ($P = \tau \cdot \omega$).
- **Enhanced `Fluid & Thermal`**: Added Volumetric Flow Rate, Darcy-Weisbach Pipe Pressure Loss, Steady-State Heat Transfer Rate, and Linear Thermal Expansion.
- Registered all new calculators in [`CalculationRegistry`](file:///Users/acs/Downloads/acs/EngineeringToolbox/EngineeringToolbox/Features/EngineeringCalculations/CalculationRegistry.swift).

### [2026-09-09 — Baseline]
- Added `ProjectStatus.md` to document the state, architecture, and feature set.
- Implemented initial `Features/EngineeringCalculations` with multi-category calculator engine, registry, and 9 engineering calculators.
- Added `Navigation/RootTabView.swift` providing a two-tab interface (`Convert` & `Calculators`).
- Reorganized codebase into `App/`, `Navigation/`, and `Features/` hierarchy using Xcode 16 synchronized groups.
