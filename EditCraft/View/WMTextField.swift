//
//  PSTextField.swift
//  ParallelSpace
//
//  Created by swati on 01/04/24.
//

import Foundation
import UIKit.UITextField

class WMTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setPlaceHolder()
    }
    
    enum Side {
        case left, right, all
        func getX() -> Int {
            switch self {
                case .left: return 10
                case .right: return 10
                case .all: return 10
            }
        }
    }
    
    func addView(at side: Side) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        switch side {
        case .left:
            leftView = containerView
            leftViewMode = .always
        case .right:
            rightView = containerView
            rightViewMode = .always
        case .all:
            leftView = containerView
            rightView = containerView
            leftViewMode = .always
            rightViewMode = .always
        }
    }
    
    func setPlaceHolder() {
        let color = UIColor.lightGray.withAlphaComponent(0.6)
        let placeholder = placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
    }
}
