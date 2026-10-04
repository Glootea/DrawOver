import SwiftUI

struct DraggableWithOffset: ViewModifier {
    let appState: AppState

    @State var dragged = CGSize.zero
    @State var accumulated = CGSize.zero

    init(appState: AppState) {
        self.appState = appState
        let offset = appState.offset
        _dragged = State(initialValue: offset)
        _accumulated = State(initialValue: offset)
    }

    func body(content: Content) -> some View {
        content
            .offset(dragged)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragged = CGSize(
                            width: value.translation.width + accumulated.width,
                            height: value.translation.height + accumulated.height)
                    }
                    .onEnded { value in
                        dragged = CGSize(
                            width: value.translation.width + accumulated.width,
                            height: value.translation.height + accumulated.height)
                        accumulated = dragged
                        appState.offset = accumulated
                    }
            )
    }
}

extension View {
    func draggableWithOffset(_ appState: AppState) -> some View {
        self.modifier(DraggableWithOffset(appState: appState))
    }
}
