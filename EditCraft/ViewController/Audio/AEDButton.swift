//
//  AEDButton.swift
//  AudioEditDemo
//
//  Created by swati on 04/09/24.
//

import Foundation
import UIKit

class AEDButton: UIButton {
    
    func setAsPrimary() {
        backgroundColor = AppColor.background
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 6
    }
    
    func setAsSecondary(radius: CGFloat) {
        layer.borderWidth = 1
        layer.borderColor = AppColor.deselect.cgColor
        layer.cornerRadius = radius
    }
}
