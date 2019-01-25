//
//  PianoSliderView.swift
//  Piano
//
//  Created by Markov, Vadym on 25/01/2019.
//  Copyright © 2019 FINN. All rights reserved.
//

import UIKit

// MARK: - Slider

final class PianoSlider: UIView {
    private(set) lazy var trackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = tintColor
        view.clipsToBounds = true
        return view
    }()

    private lazy var pointerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        trackView.layer.cornerRadius = trackView.bounds.height / 2
        pointerView.layer.cornerRadius = pointerView.bounds.height / 2
    }

    private func setup() {
        addSubview(trackView)
        addSubview(pointerView)

        trackView.fillInSuperview()

        NSLayoutConstraint.activate([
            pointerView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            pointerView.leadingAnchor.constraint(equalTo: trackView.centerXAnchor),
            pointerView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: 0.4),
            pointerView.heightAnchor.constraint(equalTo: pointerView.widthAnchor, multiplier: 0.25)
        ])
    }
}

