import Foundation
import SwiftUI

public struct OnLongPressWithLocation: ViewModifier {

    var coordinateSpaceName: String
    var onLongPress: (CGPoint) -> Void

    @GestureState private var isDetectingLongPress = false
    @State private var longPressLocation: CGPoint?

    public func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometryProxy in
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(LongPressGesture()
                            .onEnded { value in
                                if let longPressLocation {
                                    onLongPress(longPressLocation)
                                }
                            }
                            .simultaneously(with: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                            .updating($isDetectingLongPress, body: { value, state, trans in
                                let localLongPressLocation = value.second?.location ?? .zero
                                let messageViewFrameInMenuHolderCoordinates = geometryProxy.frame(in: .named(coordinateSpaceName))

                                longPressLocation = CGPoint(
                                    x: messageViewFrameInMenuHolderCoordinates.minX + localLongPressLocation.x,
                                    y: messageViewFrameInMenuHolderCoordinates.minY + localLongPressLocation.y
                                )
                            })
                            .onEnded({ value in
                                longPressLocation = .zero
                            })
                        )
                }
            }
    }
}

public extension View {
    func onLongPressWithLocation(coordinateSpaceName: String, onLongPress: @escaping (CGPoint) -> Void) -> some View {
        self.modifier(OnLongPressWithLocation(coordinateSpaceName: coordinateSpaceName, onLongPress: onLongPress))
    }
}
