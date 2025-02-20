import Foundation
import SwiftUI

// TODO: Add instrumented tests for all gestures and intermediate event handlers.
public struct OnLongPressWithLocation: ViewModifier {

    var coordinateSpaceName: String
    var useNativeLongPressWithViewCenter: Bool
    var onTap: (() -> Void)?
    var onLongPress: ((CGPoint) -> Void)?

    @State private var geometryProxy: GeometryProxy?
    @GestureState private var isDetectingLongPress = false
    @State private var longPressLocation: CGPoint?

    public func body(content: Content) -> some View {
        if useNativeLongPressWithViewCenter {
            content
                .onTapGesture {
                    onTap?()
                }
            // This transmits the view's center point, not the pressed location. However, this variant nicely works together with a DragGesture on the parent, whereas the variant with the exact location does not.
                .onLongPressGesture{
                    let viewFrameInCoordinateSpace = geometryProxy?.frame(in: .named(coordinateSpaceName)) ?? .zero
                    let viewCenter = CGPoint(
                        x: viewFrameInCoordinateSpace.midX,
                        y: viewFrameInCoordinateSpace.midY
                    )
                    onLongPress?(viewCenter)
                }
                .background {
                    GeometryReader { geometryProxy in
                        Color.clear
                            .contentShape(Rectangle())
                            .onAppear {
                                self.geometryProxy = geometryProxy
                            }
                    }
                }
        } else {
            content
                .onTapGesture {
                    onTap?()
                }
                .gesture(LongPressGesture()
                    .onEnded { value in
                        if let longPressLocation {
                            onLongPress?(longPressLocation)
                        }
                    }
                    .simultaneously(with: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                    .updating($isDetectingLongPress, body: { value, state, trans in
                        let localLongPressLocation = value.second?.location ?? .zero
                        let messageViewFrameInMenuHolderCoordinates = geometryProxy?.frame(in: .named(coordinateSpaceName)) ?? .zero

                        longPressLocation = CGPoint(
                            x: messageViewFrameInMenuHolderCoordinates.minX + localLongPressLocation.x,
                            y: messageViewFrameInMenuHolderCoordinates.minY + localLongPressLocation.y
                        )
                    })
                        .onEnded({ value in
                            longPressLocation = .zero
                        })
                )
                .background {
                    GeometryReader { geometryProxy in
                        Color.clear
                            .contentShape(Rectangle())
                            .onAppear {
                                self.geometryProxy = geometryProxy
                            }
                    }
                }
        }
    }
}
