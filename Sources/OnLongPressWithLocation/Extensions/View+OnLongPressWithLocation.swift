import Foundation
import SwiftUI

public extension View {
    func onLongPressWithLocation(
        coordinateSpaceName: String,
        useNativeLongPressWithViewCenter: Bool = false,
        onTap: (() -> Void)?,
        onLongPress: ((CGPoint) -> Void)?
    ) -> some View {
        self.modifier(OnLongPressWithLocation(
            coordinateSpaceName: coordinateSpaceName,
            useNativeLongPressWithViewCenter: useNativeLongPressWithViewCenter,
            onTap: onTap,
            onLongPress: onLongPress
        ))
    }
}
