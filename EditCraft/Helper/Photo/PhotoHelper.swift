//
//  PhotoHelper.swift
//  EditCraft
//
//  Created by swati on 06/09/24.
//

import Foundation
import Photos
import UIKit


class PhotoHelper: NSObject {
    static let shared = PhotoHelper()
    
    private override init () {
        super.init()
    }
    
    // Save the image and get the local identifier
    func saveImageToPhotoLibrary(_ image: UIImage, vc: BaseVC) {
        var localIdentifier: String = ""
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            localIdentifier = request.placeholderForCreatedAsset?.localIdentifier ?? ""
        }) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.showSaveSuccessAlert(localIdentifier: localIdentifier,
                                              image: image,
                                              vc: vc)
                } else if let error = error {
                    self.showSaveErrorAlert(error: error, vc: vc)
                }
            }
        }
    }
    
    // Show success alert
    private func showSaveSuccessAlert(localIdentifier: String, image: UIImage, vc: BaseVC) {
        let alertController = UIAlertController(title: "Photo Editor!",
                                                message: "Your image has been successfully saved to your photo library.",
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: { _ in
            DatabaseManager.sharedInstance.addECPhoto(ECPhoto(thumImage: image.pngData(),
                                                              assetIdentifier: localIdentifier))
            if let visibleVC = vc as? PhotoEditViewController {
                visibleVC.viewWillAppear(true)
            }
        }))
        
        vc.present(alertController, animated: true)
    }
    
    // Show error alert
    private func showSaveErrorAlert(error: Error, vc: BaseVC) {
        let alertController = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alertController, animated: true)
    }
    
    func deletePhoto(localIdentifier: String) {
        // Fetch the asset using the local identifier
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        
        guard let asset = assets.firstObject else {
            print("photo not found!")
            return
        }
        
        // Request deletion of the asset
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("photo successfully deleted")
                } else if let error = error {
                    print("Error deleting photo: \(error)")
                } else {
                    print("Failed to delete photo")
                }
            }
        }
    }
    
    func handleShare(localIdentifier: String, viewController: BaseVC) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        
        guard let asset = assets.firstObject, asset.mediaType == .image else {
            print("Photo not found or not a photo asset!")
            return
        }
        
        // Request UIImage data for the photo
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { (image, info) in
            guard let image = image else {
                print("Could not retrieve UIImage")
                return
            }
            
            // Present the share sheet on the main thread
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                
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
