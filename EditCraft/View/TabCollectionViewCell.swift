//
//  TabCollectionViewCell.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUI() {
        setColor()
        setFont()
    }
    
    func updateUI(isSelected: Bool = false) {
        if let superview = imgView.superview?.superview {
            superview.layer.cornerRadius = 16
            superview.backgroundColor = isSelected ? AppColor.theme : .clear
        }
        lblTitle.isHidden = !isSelected
        imgView.tintColor = isSelected ? AppColor.white : AppColor.deselect
    }
    
    func setFont() {
        lblTitle.font = AppFont.getFont(style: .title2, weight: .bold)
    }
    
    func setColor() {
        lblTitle.textColor = AppColor.white
        imgView.tintColor = AppColor.theme
    }
    
    func configData(data: TabItem) {
        imgView.image = data.getImage()?.withRenderingMode(.alwaysTemplate)
        lblTitle.text = data.getTitle()
    }
}
