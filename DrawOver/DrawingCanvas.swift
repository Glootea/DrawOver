import IOKit
import SwiftUI

struct DrawingCanvasView: View {
    @Binding var appState: AppState

    private func erase(point: CGPoint) {
        appState.lines = appState.lines.filter { line in
            !line.points.contains(where: {
                let dx = abs($0.x - point.x)
                let dy = abs($0.y - point.y)
                return dx < appState.brushThickness && dy < appState.brushThickness
            })
        }
    }

    private func draw(point: CGPoint) {
        if var currentLine = appState.currentLine {
            currentLine.points.append(point)
        } else {
            appState.currentLine = Line(
                points: [point], color: appState.brushColor, lineWidth: appState.brushThickness)
        }
        appState.lines.append(appState.currentLine!)

        if appState.currentLine == nil {
            appState.currentLine = Line(
                points: [point], color: appState.brushColor,
                lineWidth: appState.brushThickness)
        } else {
            appState.currentLine?.points.append(point)
        }
    }

    private func drawLines(context: inout GraphicsContext, size: CGSize) {
        for line in appState.lines {
            var path = Path()
            path.addLines(line.points)
            context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
        }

        if let currentLine = appState.currentLine {
            var path = Path()
            path.addLines(currentLine.points)
            context.stroke(
                path, with: .color(currentLine.color), lineWidth: currentLine.lineWidth)
        }
    }

    private var gestureHandler: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let newPoint = value.location.applying(
                    CGAffineTransform(
                        translationX: -CGFloat(CURSORWIDTH), y: -CGFloat(CURSORHEIGHT)))

                switch appState.selectedInstrument {
                case .pen:
                    draw(point: newPoint)
                case .eraser:
                    erase(point: newPoint)
                case .mouse:
                    break
                }

            }
            .onEnded { _ in
                if let line = appState.currentLine {
                    appState.lines.append(line)
                }
                appState.currentLine = nil
            }
    }

    var body: some View {
        let backgroundColor = Color.black.opacity(0.001)
        let isOverlayInteractive = appState.selectedInstrument != .mouse

        VStack {
            Canvas(renderer: drawLines)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .contentShape(Rectangle())
                .cornerRadius(8)
                .padding()
                .gesture(gestureHandler)
                .allowsHitTesting(isOverlayInteractive)
        }
    }
}
