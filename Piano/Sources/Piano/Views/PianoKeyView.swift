//
//  PianoKeyView.swift
//  Piano
//
//  Created by Vadym Markov on 27/11/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

final class PianoKeyView: UIView {
    var isAccidental = false {
        didSet {
            backgroundColor = isAccidental ? UIColor(r: 22, g: 20, b: 23) : .white
        }
    }

    var isSelected = false {
        didSet {
            alpha = isSelected ? 0.8 : 1
        }
    }
}
