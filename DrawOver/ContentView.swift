import AppKit
import Playgrounds
import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                callback(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
struct ContentView: View {
    var body: some View {
        DrawingCanvasView()
            .background(
                WindowAccessor { window in
                    window.isOpaque = false
                    window.backgroundColor = .clear
                    window.hasShadow = false
                    window.styleMask = []
                    window.setFrame(
                        NSRect(
                            x: 0, y: 0, width: NSScreen.main?.frame.width ?? 800,
                            height: NSScreen.main?.frame.height ?? 600), display: false)
                }
            )
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
