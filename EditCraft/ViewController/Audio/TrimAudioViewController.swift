import UIKit
import AVFoundation
import RangeSeekSlider
import MBProgressHUD

class TrimAudioViewController: BaseVC {
    
    @IBOutlet weak var imgWave: UIImageView!
    @IBOutlet weak var btnTrim: AEDButton!
    @IBOutlet weak var btnPlayPause: AEDButton!
    @IBOutlet weak var sliderView: RangeSeekSlider!
    
    var startLine = UIView()
    var endLine = UIView()
    var audioPlayer: AVAudioPlayer?
    
    var audioFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.string.localizable.trim()
        // Load the audio file from bundle
        if let audioFileURL {
            setupAudio(fileURL: audioFileURL)
            imgWave.image = R.image.ic_wave()
        }
        
        btnTrim.setAsPrimary()
        btnPlayPause.setAsPrimary()
        setRangeSliderUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.stop()
    }
    
    func setRangeSliderUI() {
        sliderView.handleDiameter = 30.0
        sliderView.handleColor = AppColor.theme
        sliderView.minValue = 0.0
        sliderView.selectedMinValue = 0.0
        sliderView.minLabelFont = AppFont.getFont(style: .body)!
        sliderView.maxLabelFont = AppFont.getFont(style: .body)!
        if let audioFileURL {
            sliderView.maxValue = CGFloat(Float(CMTimeGetSeconds(AVAsset(url: audioFileURL).duration)))
            sliderView.selectedMaxValue = CGFloat(Float(CMTimeGetSeconds(AVAsset(url: audioFileURL).duration)))
        }
        sliderView.lineHeight = .zero
        sliderView.numberFormatter.maximumFractionDigits = 2
        sliderView.numberFormatter.positiveSuffix = "s"
    }
    
    func setupAudio(fileURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
    
    @IBAction func sliderViewDidChange(_ sender: RangeSeekSlider) {
        
    }
    
    @IBAction func trimAudioButtonTapped(_ sender: Any) {
        let startTime = Double(sliderView.selectedMinValue)
        let endTime = Double(sliderView.selectedMaxValue)
        let duration = endTime - startTime
        guard let audioFileURL else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        trimAudio(inputURL: audioFileURL, startTime: startTime, duration: duration) { success, outputURL, error in
            if success, let outputURL = outputURL {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print("Trimmed audio successfully saved to \(outputURL)")
                }
            } else {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print("Failed to trim audio: \(error)")}
            }
        }
    }
    
    @IBAction func btnPlaySelected(_ sender: UIButton) {
        guard let audioPlayer else { return }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            sender.setTitle("Play", for: .normal)
        } else {
            audioPlayer.play()
            sender.setTitle("Pause", for: .normal)
        }
    }
}

extension TrimAudioViewController {
    func trimAudio(inputURL: URL, startTime: Double, duration: Double, completion: @escaping (Bool, URL?, String?) -> Void) {
        let asset = AVAsset(url: inputURL)
        
        let startCMTime = CMTime(seconds: startTime, preferredTimescale: 600)
        let durationCMTime = CMTime(seconds: duration, preferredTimescale: 600)
        let timeRange = CMTimeRange(start: startCMTime, duration: durationCMTime)
        
        let fileManager = FileManager.default
        
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(false, nil, "Could not find the Documents directory")
            return
        }
        
        // Generate a unique file name
        let uniqueFileName = "\(inputURL.deletingPathExtension().lastPathComponent)-\(UUID().uuidString).m4a"

        let outputURL = documentsDirectory.appendingPathComponent(uniqueFileName)
        
        // Fetch metadata: Duration, Name, and Thumbnail
        let assetName = inputURL.lastPathComponent
        let thumbnailImage = generateThumbnail(for: asset)
        
        if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .m4a
            exportSession.timeRange = timeRange
            
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    completion(true, outputURL, nil)
                    showSaveSuccessAlert()
                case .failed, .cancelled:
                    completion(false, nil, exportSession.error?.localizedDescription)
                default:
                    break
                }
            }
        } else {
            completion(false, nil, nil)
        }
        
        // Show success alert
        func showSaveSuccessAlert() {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Audio Editor!",
                                                        message: "Your music has been successfully saved to your file manager.",
                                                        preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: { _ in
                    
                    if let vcs = self.coordinator?.navigationController.viewControllers {
                        if let loginVC = vcs.first(where: {$0 is TabbarViewController}) {
                            let fileSize = self.getVideoSize(url: outputURL)
                            let duration = self.getVideoDuration(url: outputURL)
                            DatabaseManager.sharedInstance.addECAudio(ECAudio(audioURL: outputURL.absoluteString,
                                                                              thumImage: thumbnailImage?.pngData(),
                                                                              duration: "\(duration)", name: assetName,
                                                                              size: fileSize ?? ""))
                            
                            self.coordinator?.navigationController.popToViewController(loginVC,
                                                                                       animated: true)
                        }
                        
                    }
                }))
                
                self.present(alertController, animated: true)
            }
        }
    }

    func generateThumbnail(for asset: AVAsset) -> UIImage? {
        // Use AVAssetImageGenerator to extract a thumbnail
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            return R.image.ic_audio_placeholder()
        }
    }
    
    func getVideoSize(url: URL) -> String? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = attributes[.size] as? Int64 {
                let fileSizeString = string(fromByteCount: fileSize)
                return fileSizeString
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    // Function to convert byte count to appropriate string representation (KB, MB, GB)
    func string(fromByteCount byteCount: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB, .useBytes]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: byteCount)
    }
    
    func getVideoDuration(url: URL) -> String {
        let asset = AVURLAsset(url: url)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        let hours = Int(durationInSeconds) / 3600
        let minutes = (Int(durationInSeconds) % 3600) / 60
        let seconds = Int(durationInSeconds) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
