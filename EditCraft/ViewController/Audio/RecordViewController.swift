//
//  RecordViewController.swift
//  AudioEditDemo
//
//  Created by swati on 03/09/24.
//

import UIKit
import AVFoundation

class RecordViewController: BaseVC, AVAudioRecorderDelegate {

    @IBOutlet weak var imgRecordView: UIImageView!
    @IBOutlet weak var recordButton: AEDButton!
    @IBOutlet weak var saveButton: AEDButton!
    @IBOutlet weak var resetButton: AEDButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioFilename: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.string.localizable.recording()
        // Setup UI
        setupUI()

        // Request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self?.setupRecorder()
                } else {
                    // Handle permission denial
                    print("Microphone permission denied")
                }
            }
        }
    }

    func setupUI() {
        // Set up record button
        recordButton.setAsSecondary(radius: 30)
        recordButton.setImage(R.image.ic_play_record()?.withRenderingMode(.alwaysTemplate),
                              for: .normal)
        recordButton.setImage(R.image.ic_stop_record()?.withRenderingMode(.alwaysTemplate),
                              for: .selected)
        recordButton.tintColor = .red
        
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        // Set up save button
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveRecording), for: .touchUpInside)
        saveButton.isEnabled = false // Disable initially
        saveButton.isHidden = true // Hide initially
        

        // Set up reset button
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetRecording), for: .touchUpInside)
        resetButton.isEnabled = false // Disable initially
        resetButton.isHidden = true // Hide initially
        
        imgRecordView.image = R.image.ic_recording()
        
        [saveButton, resetButton].forEach({$0?.setAsPrimary()})
        springAnimation()
    }
    
    func springAnimation() {
        UIView.animate(withDuration: 1.0, // Duration for one cycle
                       animations: {
            // Expand the view
            self.imgRecordView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.imgRecordView.alpha = 0.6
        }, completion: { _ in
            // Shrink back to the original size
            UIView.animate(withDuration: 1.0, // Duration for the reverse cycle
                           animations: {
                self.imgRecordView.transform = CGAffineTransform.identity
                self.imgRecordView.alpha = 1
            }, completion: { _ in
                // Repeat the animation
                self.springAnimation()
            })
        })
    }

    func setupRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            // Prepare audio file path
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            audioFilename = paths[0].appendingPathComponent("recording.m4a")

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
        } catch {
            print("Failed to set up recorder: \(error.localizedDescription)")
        }
    }

    @objc func toggleRecording() {
        guard let audioRecorder = audioRecorder else { return }
        if audioRecorder.isRecording {
            audioRecorder.stop()
            recordButton.isSelected = false
        } else {
            audioRecorder.record()
            recordButton.isSelected = true
            saveButton.isHidden = true
            resetButton.isHidden = true
        }
        
        if audioRecorder.isRecording {
            saveButton.isHidden = false
            saveButton.isEnabled = true
            resetButton.isHidden = false
            resetButton.isEnabled = true
        }
    }

    @objc func saveRecording() {
        guard let audioRecorder = audioRecorder else { return }
        
        if audioRecorder.isRecording {
            audioRecorder.stop()
        }
        
        guard let audioFilename else { return }
        coordinator?.redirectTrimAudio(url: audioFilename)
    }

    @objc func resetRecording() {
        guard let audioRecorder = audioRecorder else { return }

        if audioRecorder.isRecording {
            audioRecorder.stop()
        }

        do {
            try FileManager.default.removeItem(at: audioFilename!)
            recordButton.isSelected = false
            saveButton.isHidden = true
            resetButton.isHidden = true
            saveButton.isEnabled = false
            resetButton.isEnabled = false
        } catch {
            print("Failed to delete audio file: \(error.localizedDescription)")
        }

        setupRecorder()
    }
}
