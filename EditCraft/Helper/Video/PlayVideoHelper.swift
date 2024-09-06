//
//  PlayVideoHelper.swift
//  VideoIt
//
//  Created by swati on 08/05/24.
//

import UIKit
import AVKit
import Photos

class PlayVideoHelper: NSObject {
    static let shared = PlayVideoHelper()
    
    private override init () {
        super.init()
    }
    
    func playVideoFromLocalIdentifier(_ localIdentifier: String, 
                                      from viewController: UIViewController) {
        
        // Fetch the asset from the Photos library using the localIdentifier
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        
        // Ensure the asset exists and is of video type
        guard let asset = assets.firstObject, asset.mediaType == .video else {
            print("No video asset found with the given localIdentifier.: - \(localIdentifier)")
            return
        }
        
        // Request the AVAsset for playback
        PHImageManager.default().requestAVAsset(forVideo: asset, options: nil) { (avAsset, audioMix, info) in
            // Ensure the AVAsset is available
            guard let avAsset = avAsset else {
                print("Unable to fetch AVAsset for the video.")
                return
            }
            
            // Play the video using AVPlayerViewController
            DispatchQueue.main.async {
                let playerItem = AVPlayerItem(asset: avAsset)
                let player = AVPlayer(playerItem: playerItem)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                // Present the AVPlayerViewController to play the video
                viewController.present(playerViewController, animated: true) {
                    player.play()  // Start video playback automatically
                }
            }
        }
    }
    
    func deleteVideo(localIdentifier: String) {
        // Fetch the asset using the local identifier
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        
        guard let asset = assets.firstObject else {
            print("Video not found!")
            return
        }
        
        // Request deletion of the asset
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("Video successfully deleted")
                } else if let error = error {
                    print("Error deleting video: \(error)")
                } else {
                    print("Failed to delete video")
                }
            }
        }
    }
    
    func handleShare(localIdentifier: String, viewController: BaseVC) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        
        guard let asset = assets.firstObject, asset.mediaType == .video else {
            print("Video not found or not a video asset!")
            return
        }
        
        // Request AVAsset and export the video to a local URL
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
            guard let urlAsset = avAsset as? AVURLAsset else {
                print("Could not retrieve AVAsset")
                return
            }
            
            // Now we have the URL of the video
            let videoURL = urlAsset.url
            
            // Present the share sheet on the main thread
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
                
                // iPad compatibility
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceView = viewController.view
                    popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                                          y: viewController.view.bounds.midY,
                                                          width: 0,
                                                          height: 0)
                    popoverController.permittedArrowDirections = []
                }
                viewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
