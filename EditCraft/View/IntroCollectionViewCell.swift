//
//  IntroCollectionViewCell.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//

import UIKit

class IntroCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI() {
        setColor()
        setFont()
    }
    
    func setColor() {
        lblTitle.textColor = AppColor.theme
        lblSubTitle.textColor = AppColor.white
    }
    
    func setFont() {
        lblTitle.font = AppFont.getFont(style: .largeTitle,
                                              weight: .bold)
        
        lblSubTitle.font = AppFont.getFont(style: .title1,
                                                 weight: .semibold)
    }
    
    func configData(data: Introduction) {
        lblTitle.text = data.getTitle()
        lblSubTitle.text = data.getSubTitle()
        imgView.image = data.getImage()
    }
    
    func configData(data: PremiumSelectionViewController.PremiumSelection) {
        lblTitle.text = data.getTitle().0
        lblSubTitle.text = data.getTitle().1
        imgView.image = data.getImage()
    }
}
