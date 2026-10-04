import SwiftUI

struct MenuBar: View {
    let appState: AppState
    @State private var showThicknessPopover = false

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
                        if appState.menuBarStyle == .horizontal{
                            Text(inst.rawValue.capitalized)
                        }

                    }.tag(inst)
                }
            }

            ColorPicker("Brush Color", selection: brushColorBinding)
                .labelsHidden()
            Button {
                showThicknessPopover = !showThicknessPopover
            } label: {
                Image(systemName: "textformat.size")
            }.popover(
                isPresented: $showThicknessPopover
            ) {
                Slider(value: brushThicknessBinding, in: 1...20) {
                    VStack {
                        Text("Thickness")
                        Spacer()
                    }
                }
                .padding()
                .frame(width: 400)
                .interactiveDismissDisabled(true)
            }

            Button(role: .destructive) {
                appState.lines.removeAll()
            } label: {
                Image(systemName: "trash")
            }
            .foregroundColor(.red)
            // .buttonStyle(.borderedProminent)

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
