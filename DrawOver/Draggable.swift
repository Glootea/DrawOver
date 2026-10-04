import SwiftUI

struct DraggableWithOffset: ViewModifier {
    @State var dragged = CGSize.zero
    @State var accumulated = CGSize.zero

    func body(content: Content) -> some View {
        content
            .offset(dragged)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        print(value.translation)
                        dragged = CGSize(
                            width: value.translation.width + accumulated.width,
                            height: value.translation.height + accumulated.height)
                    }
                    .onEnded { value in
                        dragged = CGSize(
                            width: value.translation.width + accumulated.width,
                            height: value.translation.height + accumulated.height)
                        accumulated = dragged
                    }
            )
    }
}

extension View {
    func draggableWithOffset() -> some View {
        self.modifier(DraggableWithOffset())
    }
}
