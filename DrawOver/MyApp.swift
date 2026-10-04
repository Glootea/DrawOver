import SwiftUI

@main struct MyApp: App {
    private var appStateStore: AppStateStore = AppStateStore()
    private var appState: AppState { appStateStore.appState }

    @State private var menuBarOffset: CGSize = CGSize.zero

    var body: some Scene {
        WindowGroup {
            ZStack {
                DrawingCanvasView(appState: appState)
                    .fillWholeScreen()
                    .setTransparentWindow()
                MenuBar(appState: appState)
                    .draggableWithOffset(appState)
            }
            .controlSize(.large)
            .font(.largeTitle)
        }
        .windowIdealSize(.maximum)
        .windowLevel(.floating)
    }
}
