//
//  Vibrator.swift
//  EmojiPicker
//
//  Created by levantAJ on 13/11/18.
//

import UIKit

protocol Vibratable {
    func vibrate()
}

struct Vibrator {}

// MARK: - Vibrator Conformance to Vibratable

extension Vibrator: Vibratable {
    func vibrate() {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
