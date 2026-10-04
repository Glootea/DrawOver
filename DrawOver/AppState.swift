import SwiftUI

@Observable
class AppState {
    var selectedInstrument: Instrument
    var brushColor: Color
    var brushThickness: Double
    var lines: [Line] = []
    var currentLine: Line? = nil
    var menuBarStyle: MenuBarStyle

    init(
        selectedInstrument: Instrument, brushColor: Color, brushThickness: Double,
        lines: [Line] = [], currentLine: Line? = nil, menuBarStyle: MenuBarStyle = .horizontal
    ) {
        self.selectedInstrument = selectedInstrument
        self.brushColor = brushColor
        self.brushThickness = brushThickness
        self.lines = lines
        self.currentLine = currentLine
        self.menuBarStyle = menuBarStyle
    }

    static var initial: AppState = AppState(
        selectedInstrument: .pen, brushColor: .blue, brushThickness: 3,
        menuBarStyle: .horizontal)
}

struct Line {
    var points: [CGPoint]
    var color: Color = .blue
    var lineWidth: CGFloat = 4.0
}

enum Instrument: String, CaseIterable, Identifiable {
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

enum MenuBarStyle: String, CaseIterable, Identifiable {
    case horizontal, vertical
    var id: Self { self }
    var icon: String {
        switch self {
        case .horizontal: "arrow.right"
        case .vertical: "arrow.down"
        }
    }
}
