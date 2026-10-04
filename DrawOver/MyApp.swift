import SwiftUI

@main struct MyApp: App {
    @State private var appState: AppState = AppState.initial
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {

        WindowGroup {
            MenuBar()
                .gesture(WindowDragGesture())
                .background(
                    WindowAccessor { window in
                        window.isOpaque = false
                        window.backgroundColor = .clear
                        window.hasShadow = false
                        window.styleMask = []

                    }
                )
                .environment(appState)
                .onAppear {
                    openWindow(id: "MenuBar2")
                }

        }
        .windowLevel(.floating)

        Window("DrawingCanvas", id: "MenuBar2") {
            ContentView()
                .environment(appState)
        }
        .windowResizability(.automatic)
        .windowIdealSize(.maximum)
        .windowBackgroundDragBehavior(.enabled)
    }
}
