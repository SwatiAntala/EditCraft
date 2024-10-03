//
//  Extension.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import Foundation
import UIKit
import AVFoundation

@nonobjc extension UIViewController {
    func add(_ child: UIViewController, toView viewToAdd: UIView? = nil, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        if let view = viewToAdd {
            view.addSubview(child.view)
        }
        else {
            view.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func getAppDelegate() -> AppDelegate  {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension UIImage {
    var data: Data? {
        if let data = self.jpegData(compressionQuality: 1.0) {
            return data
        } else {
            return nil
        }
    }
}

extension Data {
    var image: UIImage? {
        if let image = UIImage(data: self) {
            return image
        } else {
            return nil
        }
    }
}

extension UIView {
    func applyShadow(color: UIColor = .black,
                     opacity: Float = 0.6,
                     offset: CGSize = CGSize(width: 0, height: 0),
                     radius: CGFloat = 6) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}

extension URL {
    func generateThumbnail() -> UIImage? {
        let asset = AVAsset(url: self)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        // Set properties for better results
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.requestedTimeToleranceAfter = .zero
        assetImageGenerator.requestedTimeToleranceBefore = .zero
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        do {
            let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getVideoDuration() -> String {
        let asset = AVAsset(url: self)
        let durationKey = "duration"
        var duration = CMTime.zero
        
        // Create a dispatch group to handle asynchronous loading
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        asset.loadValuesAsynchronously(forKeys: [durationKey]) {
            defer { dispatchGroup.leave() }
            
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: durationKey, error: &error)
            
            if status == .loaded {
                duration = asset.duration
            } else {
                // Handle error if needed
                print("Failed to load duration: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        // Wait for the asynchronous operation to complete
        dispatchGroup.wait()
        
        return duration.formattedString
    }
}

extension CMTime {
    var formattedString: String {
        let totalSeconds = CMTimeGetSeconds(self)
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension Date {
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
}

extension UICollectionView {
    func setEmptyView(title: String = "") {
        let view = BackgroundView()
        view.setEmptyView(title: title)
        
        self.backgroundView = view;
        self.backgroundColor = .clear
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}

extension String {
    func getAmountAndSymbol() -> (amount: String, symbol: String) {
        // Adjusted regex pattern to capture symbols and amounts more effectively
        let regexPattern = "([\\p{Sc}\\p{L}\\.\\s/]+)?\\s*([0-9,\\.]+)\\s*([\\p{Sc}\\p{L}\\.\\s/]+)?"
        
        let trimmedExample = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let regex = try? NSRegularExpression(pattern: regexPattern, options: []) {
            if let match = regex.firstMatch(in: trimmedExample, options: [], range: NSRange(location: 0, length: trimmedExample.utf16.count)) {
                let nsString = trimmedExample as NSString
                
                let prefix = match.range(at: 1).location != NSNotFound ? nsString.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespaces) : ""
                let amount = match.range(at: 2).location != NSNotFound ? nsString.substring(with: match.range(at: 2)) : ""
                let suffix = match.range(at: 3).location != NSNotFound ? nsString.substring(with: match.range(at: 3)).trimmingCharacters(in: .whitespaces) : ""
                
                print("Original: \(self)")
                print("Prefix: '\(prefix)', Amount: '\(amount)', Suffix: '\(suffix)'\n")
                return (amount: amount, symbol: prefix + suffix)
            }
        }
        return (amount: "", symbol: "")
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

func applyDashedBorder(to view: UIView, cornerRadius: CGFloat, dashPattern: [NSNumber], borderColor: CGColor, borderWidth: CGFloat) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = borderColor
    shapeLayer.fillColor = nil
    shapeLayer.lineDashPattern = dashPattern
    shapeLayer.lineWidth = borderWidth
    shapeLayer.frame = view.bounds
    shapeLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
    
    // Apply the corner radius to the button's layer
    view.layer.cornerRadius = cornerRadius
    view.layer.masksToBounds = true
    
    // Add the dashed border as a sublayer
    view.layer.addSublayer(shapeLayer)
}
