import SwiftUI

@main struct MyApp: App {
    @State private var appState: AppState = AppState.initial
    @State private var menuBarOffset: CGSize = CGSize.zero
    @State private var dragged = CGSize.zero
    @State private var accumulated = CGSize.zero

    var body: some Scene {
        WindowGroup {
            ZStack {
                DrawingCanvasView(appState: $appState)
                    .fillWholeScreen()
                    .setTransparentWindow()
                MenuBar(appState: $appState)
                    .offset(dragged)
                    .draggableWithOffset()
            }
        }
        .windowIdealSize(.maximum)
        .environment(appState)
        .windowLevel(.floating)
    }
}
