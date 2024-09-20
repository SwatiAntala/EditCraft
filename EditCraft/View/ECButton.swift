//
//  ECButton.swift
//  EditCraft
//
//  Created by swati on 10/09/24.
//

import UIKit.UIButton

class ECButton: UIButton {
    
    func setAsPrimary() {
        backgroundColor = AppColor.theme
        setTitleColor(AppColor.white, for: .normal)
        layer.cornerRadius = cornerRadius
        titleLabel?.font = AppFont.getFont(style: .title3, weight: .bold)
    }
}
