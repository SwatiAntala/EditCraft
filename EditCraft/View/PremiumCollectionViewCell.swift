//
//  PremiumCollectionViewCell.swift
//  EditCraft
//
//  Created by swati on 09/09/24.
//

import UIKit

class PremiumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var btnPlanName: ECButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI() {
        setFont()
        setColor()
        
        if let superview = lblTitle.superview?.superview?.superview {
            superview.backgroundColor = AppColor.background
            superview.layer.cornerRadius = cornerRadius
        }
    }
    
    func updateUI(isSelected: Bool = false) {
        if let superview = lblTitle.superview?.superview?.superview {
            if isSelected {
                superview.layer.borderColor = AppColor.theme.cgColor
                superview.layer.borderWidth = 1
            } else {
                superview.layer.borderColor = UIColor.clear.cgColor
                superview.layer.borderWidth = 1
            }
        }
    }
    
    func setFont() {
        lblTitle.font = AppFont.getFont(style: .title2, weight: .medium)
        lblActualPrice.font = AppFont.getFont(style: .title2, weight: .medium)
        lblOfferPrice.font = AppFont.getFont(style: .title2, size: 32, weight: .bold)
        btnPlanName.titleLabel?.font = AppFont.getFont(style: .title2,
                                                       weight: .bold)
    }
    
    func setColor() {
        lblTitle.textColor = AppColor.Text.secondary
        lblActualPrice.textColor = AppColor.Text.secondary
        lblOfferPrice.textColor = AppColor.white
        lblOfferPrice.backgroundColor = AppColor.backgroundSecondary
        btnPlanName.setTitleColor(AppColor.white, for: .normal)
        btnPlanName.layer.cornerRadius = cornerRadius
    }
    
    func configData(data: Premium) {
        lblTitle.text = data.title
        btnPlanName.setTitle(data.subTitle, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            applyDashedBorder(to: self.btnPlanName,
                              cornerRadius: cornerRadius,
                              dashPattern: [4,6],
                              borderColor: data.color.cgColor,
                              borderWidth: 1.5)
        }
        
        imgView.image = data.image
        lblOfferPrice.text = data.getPrice()
        
        
        let discountPrice = Double(data.getInAppPrice()) ?? 0.0
        let percentage = Double(AppData.sharedInstance.offerInAppPercentage) ?? 0.0
        let decimal = 1 - (percentage/100.0)
        
        let regularPrice = discountPrice/decimal
    
        let result = data.getPrice().getAmountAndSymbol()
        let symbol = result.symbol
        
        lblActualPrice.attributedText = formatPrice(regularPrice, with: symbol).strikeThrough()
    }
    
    func formatPrice(_ price: Double, with symbol: String) -> String {
        return String(format: "\(symbol)%.2f", price)
    }
}
