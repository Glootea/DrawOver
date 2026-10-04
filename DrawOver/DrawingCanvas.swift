import SwiftUI
import IOKit

struct DrawingCanvasView: View {

    @Environment(AppState.self) private var appState

    var body: some View {
        let backgroundColor = Color.black.opacity(0.001)

        let isOverlayInteractive = appState.selectedInstrument != .mouse

        VStack {
            Canvas { context, size in
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
            .contentShape(Rectangle())
            .cornerRadius(8)
            .padding()
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let newPoint = value.location.applying(CGAffineTransform(translationX: -CGFloat(CURSORWIDTH) , y: -CGFloat(CURSORHEIGHT)))
                        if appState.currentLine == nil {
                            appState.currentLine = Line(
                                points: [newPoint], color: appState.brushColor,
                                lineWidth: appState.brushThickness)
                        } else {
                            appState.currentLine?.points.append(newPoint)
                        }
                    }
                    .onEnded { _ in
                        if let line = appState.currentLine {
                            appState.lines.append(line)
                        }
                        appState.currentLine = nil
                    }
            )
            .allowsHitTesting(isOverlayInteractive)
        }
    }
}
