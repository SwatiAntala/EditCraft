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
        titleLabel?.font = AppFont.getFont(style: .title1, weight: .bold)
    }
    
    func setAsSecondary(radius: CGFloat) {
        layer.borderWidth = 1
        layer.borderColor = AppColor.deselect.cgColor
        layer.cornerRadius = radius
    }
}
