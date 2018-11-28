//
//  UIColor+RGB.swift
//  Piano
//
//  Created by Vadym Markov on 28/11/2018.
//  Copyright © 2018 FINN. All rights reserved.
//

import UIKit

extension UIColor {
    // swiftlint:disable:next identifier_name
    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
