import SwiftUI

extension View {
    func fillWholeScreen() -> some View {
        self.onAppear {
            DispatchQueue.main.async {
                if let window = NSApplication.shared.windows.last,
                    let screen = window.screen ?? NSScreen.main
                {
                    window.setFrame(screen.frame, display: true)
                }
            }
        }
    }

    func setTransparentWindow() -> some View {
        self.background(
            WindowAccessor { window in
                window.isOpaque = false
                window.backgroundColor = .clear
                window.hasShadow = false
                window.styleMask = []
            }
        )
    }

}
