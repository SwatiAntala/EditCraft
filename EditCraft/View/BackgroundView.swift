//
//  BackgroundView.swift
//  VideoIt
//
//  Created by swati on 03/05/24.
//

import Foundation
import UIKit

class BackgroundView: VICustomView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblThree: UILabel!
    
    
    override func commonInit() {
         super.commonInit()
        setUI()
    }
    
    func setUI() {
        setFont()
        setColor()
    }
    
    func setFont() {
        lblThree.font = AppFont.getFont(style: .body)
    }
    
    @objc func setColor() {
        lblThree.textColor = AppColor.Text.secondary
    }
    
    func setEmptyView(title: String = "") {
        lblThree.text = title
        imgView.image = R.image.ic_no_data()
    }
}
