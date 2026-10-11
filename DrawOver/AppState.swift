import SwiftUI

@MainActor
@Observable
final class AppStateStore {
    var appState: AppState {
        didSet {
            print("Called save")
            save()
        }
    }

    private let key = "appState"
    private var saveTask: Task<Void, Never>?

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode(AppState.self, from: data)
        {
            appState = saved
        } else {
            appState = AppState()
        }

        trackChanges()
    }

    func trackChanges() {
        withObservationTracking {
            _ = appState.brushColor
            _ = appState.brushThickness
            _ = appState.lines
            _ = appState.currentLine
            _ = appState.menuBarStyle
            _ = appState.offset
        } onChange: { [weak self] in
            Task { @MainActor [weak self] in
                guard let self else { return }

                self.saveTask?.cancel()
                self.saveTask = Task { @MainActor [weak self] in
                    do {
                        try await Task.sleep(for: .milliseconds(300))
                    } catch {
                        return
                    }

                    guard !Task.isCancelled else { return }
                    self?.save()
                    self?.trackChanges()
                }
            }
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(appState) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

@Observable
final class AppState: Codable {
    var selectedInstrument: Instrument
    var brushColor: ColorComponents
    var brushThickness: Double
    var lines: [Line] = []
    var currentLine: Line?
    var menuBarStyle: MenuBarStyle
    var offset: CGSize

    init(
        selectedInstrument: Instrument = .pen, brushColor: ColorComponents = .fromColor(.blue),
        brushThickness: Double = 3.0, lines: [Line] = [], currentLine: Line? = nil,
        menuBarStyle: MenuBarStyle = .horizontal, offset: CGSize = .zero
    ) {
        self.selectedInstrument = selectedInstrument
        self.brushColor = brushColor
        self.brushThickness = brushThickness
        self.lines = lines
        self.currentLine = currentLine
        self.menuBarStyle = menuBarStyle
        self.offset = offset
    }
}

class Line: Codable {
    var points: [CGPoint]
    var colorComponents: ColorComponents = .fromColor(.blue)
    var lineWidth: CGFloat = 4.0

    init(
        points: [CGPoint], lineWidth: CGFloat = 4.0,
        colorComponents: ColorComponents = .fromColor(.blue),
    ) {
        self.points = points
        self.colorComponents = colorComponents
        self.lineWidth = lineWidth
    }
}

enum Instrument: String, CaseIterable, Identifiable, Codable {
    case pen, eraser, mouse
    var id: Self { self }
    var icon: String {
        switch self {
        case .eraser: "eraser"
        case .mouse: "computermouse"
        case .pen: "pencil"
        }
    }
}

enum MenuBarStyle: String, CaseIterable, Identifiable, Codable {
    case horizontal, vertical
    var id: Self { self }
    var icon: String {
        switch self {
        case .horizontal: "arrow.right"
        case .vertical: "arrow.down"
        }
    }
}

struct ColorComponents: Codable {
    let red: Float
    let green: Float
    let blue: Float
    let opacity: Float

    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(opacity))
    }

    static func fromColor(_ color: Color) -> ColorComponents {
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue,
            opacity: resolved.opacity,
        )
    }
}
