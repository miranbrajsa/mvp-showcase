//
//  KeyboardReactingViewController+Types.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import UIKit

struct KeyboardAnimationInfo {
    let duration: Double
    let keyboardHeight: CGFloat
    let curve: UInt
}

enum KeyboardState {
    case willShow(KeyboardAnimationInfo)
    case willHide(KeyboardAnimationInfo)
}
