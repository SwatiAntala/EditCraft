//
//  SettingCollectionViewCell.swift
//  VideoIt
//
//  Created by swati on 30/04/24.
//

import UIKit

protocol SettingViewDelegate: AnyObject {
    func viewTapped(viaSender sender: UITapGestureRecognizer)
}

class SettingView: VICustomView {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
   
    weak var actionDelegate: SettingViewDelegate?
    
    func setUI() {
        setFont()
        setColor()
        setImage()
        setGesture()
    }
    
    func setFont() {
        lblTitle.font = AppFont.getFont(style: .headline, weight: .medium)
        lblSubTitle.font = AppFont.getFont(style: .footnote, weight: .medium)
    }
    
    func setColor() {
        lblTitle.textColor = AppColor.white
        lblSubTitle.textColor = AppColor.Text.secondary
        self.backgroundColor = AppColor.backgroundSecondary
        self.layer.cornerRadius = 16
    }
    
    func setImage() {
        imgArrow.image = UIImage(systemName: "chevron.forward")
        imgArrow.tintColor = AppColor.deselect
    }
    
    func setGesture() {
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(viewTapped(_:)))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    func configData(data: Setting) {
        lblTitle.text = data.title
        lblSubTitle.text = data.subTitle
        imgView.image = data.image
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        actionDelegate?.viewTapped(viaSender: sender)
    }
}
