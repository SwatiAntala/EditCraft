//
//  PlayAudioHelper.swift
//  EditCraft
//
//  Created by swati on 09/09/24.
//

import Foundation
import AVFoundation

class PlayAudioHelper: NSObject, AVAudioPlayerDelegate {

    static let shared = PlayAudioHelper()

    private override init() {
        super.init()
    }

    var audioPlayer: AVAudioPlayer?
    var audioCompletionHandler: (() -> Void)?

    func setupAudio(fileURL: URL, completion: @escaping () -> Void) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            audioCompletionHandler = completion
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
    
    func checkPlay() -> Bool {
        guard let audioPlayer else { return false }
        return audioPlayer.isPlaying
    }

    func play() {
        guard let audioPlayer else { return }
        audioPlayer.play()
    }

    func pause() {
        guard let audioPlayer else { return }
        audioPlayer.pause()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    // Delegate method to handle completion
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioCompletionHandler?()
    }
}
