//
//  PianoEffectIndicator.swift
//  Piano
//
//  Created by Markov, Vadym on 25/01/2019.
//  Copyright © 2019 FINN. All rights reserved.
//

import UIKit

final class PianoEffectIndicatorsView: UIView {
    private let instanceCount: Int
    private let angleRange: CGFloat

    private var rotationAngle: CGFloat {
        return angleRange / CGFloat(instanceCount - 1)
    }

    private lazy var replicatorLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.instanceCount = instanceCount
        layer.preservesDepth = false
        layer.instanceColor = UIColor.white.cgColor
        layer.instanceTransform = CATransform3DMakeRotation(rotationAngle, 0.0, 0.0, 1.0)
        return layer
    }()

    private lazy var dotInstanceLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()

    // MARK: - Init

    init(instanceCount: Int, angleRange: CGFloat) {
        self.instanceCount = instanceCount
        self.angleRange = angleRange
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        replicatorLayer.frame = bounds

        let dotSize: CGFloat = 4
        let midY = bounds.midY - dotSize / 2.0
        dotInstanceLayer.frame = CGRect(x: bounds.maxX, y: midY, width: dotSize, height: dotSize)
        dotInstanceLayer.cornerRadius = dotSize / 2
    }

    // MARK: - Setup

    private func setup() {
        layer.addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(dotInstanceLayer)
    }
}
