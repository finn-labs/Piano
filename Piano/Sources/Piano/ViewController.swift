//
//  ViewController.swift
//  Piano
//
//  Created by Vadym Markov on 27/11/2018.
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    private let notes: [UInt8] = {
        let octave: UInt8 = 5
        let root: UInt8 = octave * 12
        let numberOfNotesInOctave: UInt8 = 12

        return (0..<numberOfNotesInOctave).map({ root + $0 })
    }()

    private lazy var sampler = AVAudioUnitSampler()

    private lazy var audioEngine: AVAudioEngine = {
        let audioEngine = AVAudioEngine()

        audioEngine.attach(reverb)
        audioEngine.attach(delay)
        audioEngine.attach(sampler)

        audioEngine.connect(sampler, to: reverb, format: nil)
        audioEngine.connect(reverb, to: delay, format: nil)
        audioEngine.connect(delay, to: audioEngine.mainMixerNode, format: nil)

        return audioEngine
    }()

    private lazy var reverb: AVAudioUnitReverb = {
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.cathedral)
        reverb.wetDryMix = 0
        return reverb
    }()

    private lazy var delay: AVAudioUnitDelay = {
        let delay = AVAudioUnitDelay()
        delay.wetDryMix = 0
        return delay
    }()

    private lazy var pianoView: PianoView = {
        let pianoView = PianoView()
        pianoView.translatesAutoresizingMaskIntoConstraints = false
        pianoView.dataSource = self
        pianoView.delegate = self
        return pianoView
    }()

    private lazy var reverbControl: PianoEffectControl = {
        let control = PianoEffectControl()
        control.delegate = self
        control.translatesAutoresizingMaskIntoConstraints = false
        control.sliderColor = UIColor(r: 50, g: 162, b: 255)
        control.titleLabel.text = "reverb"
        return control
    }()

    private lazy var delayControl: PianoEffectControl = {
        let control = PianoEffectControl()
        control.delegate = self
        control.translatesAutoresizingMaskIntoConstraints = false
        control.sliderColor = UIColor(r: 255, g: 75, b: 0)
        control.titleLabel.text = "delay"
        return control
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadSoundBankInstrument()
        startAudio()
    }

    // MARK: - Setup

    private func setup() {
        view.backgroundColor = UIColor(r: 216, g: 219, b: 227)

        view.addSubview(pianoView)
        view.addSubview(reverbControl)
        view.addSubview(delayControl)

        let widthMultiplier: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.6 : 0.9
        let heightMultiplier: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0.63
        let yConstraint: NSLayoutConstraint

        if UIDevice.current.userInterfaceIdiom == .pad {
            yConstraint = pianoView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        } else {
            yConstraint = pianoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        }

        NSLayoutConstraint.activate([
            yConstraint,
            pianoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pianoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier),
            pianoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier),

            reverbControl.bottomAnchor.constraint(equalTo: pianoView.topAnchor, constant: -20),
            reverbControl.trailingAnchor.constraint(equalTo: pianoView.centerXAnchor),
            reverbControl.widthAnchor.constraint(equalToConstant: 100),
            reverbControl.heightAnchor.constraint(equalTo: reverbControl.widthAnchor),

            delayControl.bottomAnchor.constraint(equalTo: reverbControl.bottomAnchor),
            delayControl.leadingAnchor.constraint(equalTo: reverbControl.trailingAnchor, constant: 70),
            delayControl.widthAnchor.constraint(equalTo: reverbControl.widthAnchor),
            delayControl.heightAnchor.constraint(equalTo: delayControl.widthAnchor)
        ])

        pianoView.reloadData()
    }

    // MARK: - Audio

    private func loadSoundBankInstrument() {
        guard let url = Bundle.main.url(forResource: "Piano", withExtension: ".sf2") else {
            print("Failed to load sound bank instrument")
            return
        }

        do {
            let bankMSB = UInt8(kAUSampler_DefaultMelodicBankMSB)
            let bankLSB = UInt8(kAUSampler_DefaultBankLSB)
            try sampler.loadSoundBankInstrument(at: url, program: 0, bankMSB: bankMSB, bankLSB: bankLSB)
        } catch {
            print(error)
        }
    }

    private func startAudio() {
        let audioSession = AVAudioSession.sharedInstance()

        // start engine, set up audio session
        do {
            try audioEngine.start()
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("set up failed")
            return
        }
    }
}

// MARK: - PianoViewDataSource

extension ViewController: PianoViewDataSource {
    func pianoViewNumberOfKeyViews(_ pianoView: PianoView) -> Int {
        return notes.count
    }
}

// MARK: - PianoViewDelegate

extension ViewController: PianoViewDelegate {
    func pianoView(_ pianoView: PianoView, didSelectKeyViewAt index: Int) {
        let note = notes[index]
        sampler.startNote(note, withVelocity: 120, onChannel: 0)
    }

    func pianoView(_ pianoView: PianoView, didDeselectKeyViewAt index: Int) {
        let note = notes[index]
        sampler.stopNote(note, onChannel: 0)
    }
}

// MARK: - PianoEffectControlDelegate

extension ViewController: PianoEffectControlDelegate {
    func pianoEffectControl(_ control: PianoEffectControl, didChangeValue value: Float) {
        if control == reverbControl {
            reverb.wetDryMix = value * 100
        } else if control == delayControl {
            delay.wetDryMix = value * 100
        }
    }
}
