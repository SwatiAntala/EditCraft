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
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnPlanName: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.applyDashedBorder(to: self.btnPlanName,
                                   cornerRadius: cornerRadius,
                                   dashPattern: [3, 6],
                                   borderColor: AppColor.Text.secondary.cgColor,
                                   borderWidth: 1)
        }
    }
    
    func setUI() {
        setFont()
        setColor()
        
        if let superview = lblTitle.superview?.superview {
            superview.backgroundColor = AppColor.background
            superview.layer.cornerRadius = cornerRadius
        }
    }
    
    func updateUI(isSelected: Bool = false) {
        if let superview = lblTitle.superview?.superview {
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
        lblTitle.font = AppFont.getFont(style: .footnote, weight: .medium)
        
        lblPrice.font = AppFont.getFont(style: .body, weight: .medium)
        
        btnPlanName.titleLabel?.font = AppFont.getFont(style: .footnote, weight: .medium)
    }
    
    func setColor() {
        lblTitle.textColor = AppColor.Text.secondary
        lblPrice.textColor = AppColor.white
        lblPrice.backgroundColor = AppColor.backgroundSecondary
    }
    
    func configData(data: Premium) {
        lblTitle.text = data.title
        btnPlanName.setTitle(data.subTitle, for: .normal)
        btnPlanName.setTitleColor(data.color, for: .normal)
        imgView.image = data.image
        lblPrice.text = data.getPrice()
    }
    
    func applyDashedBorder(to view: UIView, cornerRadius: CGFloat, dashPattern: [NSNumber], borderColor: CGColor, borderWidth: CGFloat) {
           let shapeLayer = CAShapeLayer()
           shapeLayer.strokeColor = borderColor
           shapeLayer.fillColor = nil
           shapeLayer.lineDashPattern = dashPattern
           shapeLayer.lineWidth = borderWidth
           shapeLayer.frame = view.bounds
           shapeLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
           
           // Apply the corner radius to the button's layer
           view.layer.cornerRadius = cornerRadius
           view.layer.masksToBounds = true
           
           // Add the dashed border as a sublayer
           view.layer.addSublayer(shapeLayer)
       }
}
