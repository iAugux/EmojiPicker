//
//  UIColor.swift
//  EmojiPicker
//
//  Created by levantAJ on 13/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255
        let green = CGFloat((hex >> 8) & 0xFF) / 255
        let blue = CGFloat((hex >> 0) & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
