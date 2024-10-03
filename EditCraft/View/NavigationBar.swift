//
//  NavigationBar.swift
//  WAMessenger
//
//  Created by swati on 26/09/24.
//

import UIKit

// MARK: - NavigationBar
class NavigationBar: UINavigationBar {
    
    var preferredHeight: CGFloat = 44
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var newFrame = newValue
            newFrame.size.height = preferredHeight
            super.frame = newFrame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the frame with the preferred height
        frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: preferredHeight)

        // Adjust the content layout to center the title
        for subview in subviews {
            if NSStringFromClass(subview.classForCoder).contains("UINavigationBarContentView") {
                let contentView = subview
                var frame = contentView.frame
                frame.origin.y = (preferredHeight - contentView.frame.height) / 2
                contentView.frame = frame
            }
        }
    }
    
    // Set title and back button customization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set title attributes (centered title)
        self.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: AppFont.getFont(style: .title1, weight: .bold) as Any
        ]
        
        // Set custom back button image
        if let backImage = UIImage(named: "ic_back") {
            self.backIndicatorImage = backImage
            self.backIndicatorTransitionMaskImage = backImage
        }
        
        // Optionally hide back button text
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    }
}
