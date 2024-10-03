
class WaveformView: UIView {

    var level: Float = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)

        let midY = bounds.height / 2
        let maxAmplitude = bounds.height / 2
        let normalizedLevel = max(0.1, CGFloat(level))

        let path = UIBezierPath()

        for x in stride(from: 0, to: bounds.width, by: 4) {
            let scaling = -pow(1 / bounds.width * x - 0.5, 2) + 0.5
            let amplitude = maxAmplitude * normalizedLevel * scaling
            path.move(to: CGPoint(x: x, y: midY - amplitude))
            path.addLine(to: CGPoint(x: x, y: midY + amplitude))
        }

        path.lineWidth = 2.0
        UIColor.red.setStroke()
        path.stroke()
    }
}

import UIKit
import AVFoundation

class RecordViewController: BaseVC, AVAudioRecorderDelegate {

    @IBOutlet weak var imgRecordView: UIImageView!
    @IBOutlet weak var recordButton: AEDButton!
    @IBOutlet weak var saveButton: AEDButton!
    @IBOutlet weak var resetButton: AEDButton!
    @IBOutlet weak var recordingTimeLabel: UILabel!
    
    var waveformView: WaveformView!
    var audioRecorder: AVAudioRecorder?
    var audioFilename: URL?
    var recordingTimer: Timer?
    var displayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = R.string.localizable.recording()
        setupUI()

        // Request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self?.setupRecorder()
                } else {
                    print("Microphone permission denied")
                }
            }
        }
    }

    func setupUI() {
        // Set up record button
        recordButton.setAsSecondary(radius: 50)
        recordButton.setImage(R.image.ic_play_record()?.withRenderingMode(.alwaysTemplate),
                              for: .normal)
        recordButton.setImage(R.image.ic_stop_record()?.withRenderingMode(.alwaysTemplate),
                              for: .selected)
        recordButton.tintColor = .red
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)

        // Set up save and reset buttons
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveRecording), for: .touchUpInside)
        saveButton.isEnabled = false
        saveButton.isHidden = true

        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetRecording), for: .touchUpInside)
        resetButton.isEnabled = false
        resetButton.isHidden = true

        // Set up recording time label
        recordingTimeLabel.text = "00:00"
        
        recordingTimeLabel.font = AppFont.getFont(style: .title2, weight: .bold)
        
        imgRecordView.image = R.image.ic_recording()
        [saveButton, resetButton].forEach({$0?.setAsPrimary()})
        
        // Set up waveform view
        waveformView = WaveformView(frame: CGRect(x: 0,
                                                  y: recordingTimeLabel.frame.origin.y - 100,
                                                  width: view.bounds.width,
                                                  height: 100))
        waveformView.backgroundColor = .clear
        view.addSubview(waveformView)
        
        springAnimation()
    }

    func springAnimation() {
        UIView.animate(withDuration: 1.0, animations: {
            self.imgRecordView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.imgRecordView.alpha = 0.6
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.imgRecordView.transform = CGAffineTransform.identity
                self.imgRecordView.alpha = 1
            }, completion: { _ in
                self.springAnimation()
            })
        })
    }

    func setupRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

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
            audioRecorder?.isMeteringEnabled = true // Enable metering
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
            stopRecordingTimer()
            stopWaveformAnimation()
        } else {
            audioRecorder.record()
            recordButton.isSelected = true
            startRecordingTimer()
            startWaveformAnimation()
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
            stopRecordingTimer()
            stopWaveformAnimation()
            recordingTimeLabel.text = "00:00" // Reset time
        } catch {
            print("Failed to delete audio file: \(error.localizedDescription)")
        }

        setupRecorder()
    }

    func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRecordingTime), userInfo: nil, repeats: true)
    }

    @objc func updateRecordingTime() {
        guard let audioRecorder = audioRecorder else { return }
        
        let elapsedTime = audioRecorder.currentTime
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60

        recordingTimeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }

    func startWaveformAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWaveform))
        displayLink?.add(to: .current, forMode: .common)
        animateWaveformView()
    }
    
    func animateWaveformView() {
        let screenWidth = view.bounds.width
        let viewWidth: CGFloat = waveformView.bounds.width // Width of your waveform view
        
        // Set the initial position (off-screen to the right)
        waveformView.frame.origin.x = screenWidth
        
        // Animate the waveform view to move from right to left
        UIView.animate(withDuration: 10.0, // Duration of the animation
                       delay: 0.0,
                       options: [.curveLinear, .repeat],
                       animations: {
            self.waveformView.frame.origin.x = -viewWidth
        }, completion: { _ in
            // Optionally handle completion
        })
    }

    func stopWaveformAnimation() {
        displayLink?.invalidate()
        displayLink = nil
        waveformView.layer.removeAllAnimations()
    }

    @objc func updateWaveform() {
        guard let audioRecorder = audioRecorder else { return }
        
        audioRecorder.updateMeters()
        let level = audioRecorder.averagePower(forChannel: 0)
        let normalizedLevel = pow(10, level / 20) // Convert to a 0-1 range
        waveformView.level = normalizedLevel
    }

    // Stop recording, timer, and animation when view disappears
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        }
        stopRecordingTimer()
        stopWaveformAnimation()
    }
}
