import UIKit

protocol PianoEffectControlDelegate: AnyObject {
    func pianoEffectControl(_ control: PianoEffectControl, didChangeValue value: Float)
}

final class PianoEffectControl: UIView {
    weak var delegate: PianoEffectControlDelegate?

    var sliderColor: UIColor? {
        didSet {
            sliderView.trackView.backgroundColor = sliderColor
        }
    }

    private(set) var value: CGFloat = 0
    private let minimumValue: CGFloat = 0
    private let maximumValue: CGFloat = 1
    private let startAngle: CGFloat = -.pi * 5 / 4
    private var endAngle: CGFloat = .pi / 4
    private lazy var pointerAngle: CGFloat = startAngle

    private var angleRange: CGFloat {
        return endAngle - startAngle
    }

    private var valueRange: CGFloat {
        return maximumValue - minimumValue
    }

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(r: 143, g: 145, b: 150)
        label.textAlignment = .center
        return label
    }()

    private lazy var sliderView: PianoSlider = {
        let view = PianoSlider()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var indicatorsView: PianoEffectIndicatorsView = {
        let view = PianoEffectIndicatorsView(instanceCount: 10, angleRange: angleRange)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform(rotationAngle: startAngle)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func setValue(_ newValue: CGFloat) {
        value = min(maximumValue, max(minimumValue, newValue))
        pointerAngle = (value - minimumValue) / valueRange * angleRange + startAngle
        sliderView.transform = CGAffineTransform(rotationAngle: pointerAngle)
    }

    // MARK: - Setup

    private func setup() {
        setValue(minimumValue)

        addSubview(indicatorsView)
        addSubview(sliderView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            indicatorsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            indicatorsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorsView.widthAnchor.constraint(equalToConstant: 80),
            indicatorsView.heightAnchor.constraint(equalTo: indicatorsView.widthAnchor),

            sliderView.centerXAnchor.constraint(equalTo: indicatorsView.centerXAnchor),
            sliderView.centerYAnchor.constraint(equalTo: indicatorsView.centerYAnchor),
            sliderView.widthAnchor.constraint(equalToConstant: 64),
            sliderView.heightAnchor.constraint(equalTo: sliderView.widthAnchor)
        ])

        let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
    }

    // MARK: - Gestures

    @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
        let midPointAngle = (2 * .pi + startAngle - endAngle) / 2 + endAngle
        var boundedAngle = gesture.angle

        if boundedAngle > midPointAngle {
            boundedAngle -= 2 * .pi
        } else if boundedAngle < (midPointAngle - 2 * .pi) {
            boundedAngle -= 2 * .pi
        }

        boundedAngle = min(endAngle, max(startAngle, boundedAngle))


        let angleValue = (boundedAngle - startAngle) / angleRange * valueRange + minimumValue

        setValue(angleValue)

        if gesture.state == .ended || gesture.state == .cancelled {
            delegate?.pianoEffectControl(self, didChangeValue: Float(value))
        }
    }
}

// MARK: - Private types

private class RotationGestureRecognizer: UIPanGestureRecognizer {
    private(set) var angle: CGFloat = 0

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        updateAngle(with: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateAngle(with: touches)
    }

    private func updateAngle(with touches: Set<UITouch>) {
        guard let touch = touches.first, let view = view else {
            return
        }

        let point = touch.location(in: view)
        let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        angle = atan2(centerOffset.y, centerOffset.x)
    }
}

