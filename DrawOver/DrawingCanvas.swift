import IOKit
import SwiftUI

struct DrawingCanvasView: View {
    let appState: AppState
    @State private var pointerPosition: CGPoint = .zero
    let eraseRadiusMultiplier = 2.0

    private func erase(cursor: CGPoint) {
        var newLines: [Line] = []

        for line in appState.lines {
            var currentLine = Line.init(
                points: [], lineWidth: line.lineWidth, colorComponents: line.colorComponents)
            for point in line.points {
                let dx = abs(cursor.x - point.x)
                let dy = abs(cursor.y - point.y)
                if !(dx < (appState.brushThickness * eraseRadiusMultiplier)
                    && dy < (appState.brushThickness * eraseRadiusMultiplier))
                {
                    currentLine.points.append(point)
                } else {
                    newLines.append(currentLine)
                    currentLine = Line.init(
                        points: [point], lineWidth: line.lineWidth,
                        colorComponents: line.colorComponents)
                }
            }
            if !currentLine.points.isEmpty {
                newLines.append(currentLine)
            }
        }
        appState.lines = newLines
    }

    private func drawPointer(context: inout GraphicsContext, size: CGSize) {
        if appState.selectedInstrument != .eraser {
            return
        }
        let brushThickness = appState.brushThickness * eraseRadiusMultiplier
        let circleRect = CGRect(
            x: pointerPosition.x,
            y: pointerPosition.y,
            width: brushThickness, height: brushThickness)
        let circlePath = Path(ellipseIn: circleRect)
        context.stroke(circlePath, with: .color(.red.opacity(0.5)), lineWidth: 3)

    }

    private func draw(point: CGPoint) {
        let brushThickness = appState.brushThickness
        let brushColor = appState.brushColor

        if let currentLine = appState.currentLine {
            currentLine.points.append(point)
        } else {
            appState.currentLine = Line(
                points: [point], lineWidth: brushThickness, colorComponents: brushColor)
        }
    }

    private func drawLines(context: inout GraphicsContext, size: CGSize) {
        let lines = appState.lines

        for line in lines {
            var path = Path()
            path.addLines(line.points)
            context.stroke(
                path, with: .color(line.colorComponents.color), lineWidth: line.lineWidth)
        }

        if let currentLine = appState.currentLine {
            var path = Path()
            path.addLines(currentLine.points)
            context.stroke(
                path, with: .color(currentLine.colorComponents.color),
                lineWidth: currentLine.lineWidth)
        }

        drawPointer(context: &context, size: size)
    }

    private var gestureHandler: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let newPoint = value.location.applying(
                    CGAffineTransform(
                        translationX: -CGFloat(CURSORWIDTH), y: -CGFloat(CURSORHEIGHT)))
                pointerPosition = newPoint

                switch appState.selectedInstrument {
                case .pen:
                    draw(point: newPoint)
                case .eraser:
                    erase(cursor: newPoint)
                case .mouse:
                    break
                }

            }
            .onEnded { _ in
                if let line = appState.currentLine {
                    appState.lines.append(line)
                }
                appState.currentLine = nil
                print(appState.lines.count)
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
