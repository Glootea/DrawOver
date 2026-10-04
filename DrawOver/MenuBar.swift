import SwiftUI

struct MenuBar: View {
    let appState: AppState

    var body: some View {

        let selectedInstrumentBinding = Binding(
            get: { appState.selectedInstrument },
            set: { appState.selectedInstrument = $0 }
        )

        let brushColorBinding = Binding(
            get: { appState.brushColor.color },
            set: { appState.brushColor = ColorComponents.fromColor($0) }
        )

        let brushThicknessBinding = Binding(
            get: { appState.brushThickness },
            set: { appState.brushThickness = $0 }
        )

        let menuBarStyleBinding = Binding(
            get: { appState.menuBarStyle },
            set: { appState.menuBarStyle = $0 }
        )

        let layout =
            switch appState.menuBarStyle {
            case .horizontal: AnyLayout(HStackLayout())
            case .vertical: AnyLayout(VStackLayout())
            }

        layout {
            Picker("", selection: selectedInstrumentBinding) {
                ForEach(Instrument.allCases) { inst in
                    HStack {
                        Image(systemName: inst.icon)
                        Text(inst.rawValue.capitalized)

                    }.tag(inst)
                }
            }

            ColorPicker("Brush Color", selection: brushColorBinding)
                .labelsHidden()

            Slider(value: brushThicknessBinding, in: 1...20) {
                Text("Thickness")
            }
            .frame(width: 150)

            Button("Clear All") {
                appState.lines.removeAll()
            }
            .buttonStyle(.borderedProminent)

            Picker("", selection: menuBarStyleBinding) {
                ForEach(MenuBarStyle.allCases) { inst in
                    HStack {
                        Image(systemName: inst.icon)
                    }.tag(inst)
                }
            }
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
    }
}
