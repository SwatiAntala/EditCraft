//
//  EditVideoCollectionViewCell.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import UIKit

protocol EditVideoCellDelegate: AnyObject {
    func btnMoreSelected(fromCell cell: EditVideoCollectionViewCell, viaSender sender: UIButton)
}

class EditVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    weak var actionDelegate: EditVideoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI() {
        setColor()
        setFont()
    }
    
    func hideView() {
        imgPlay.isHidden = true
        lblDuration.isHidden = true
    }
    
    func setColor() {
        lblDuration.textColor = AppColor.black
        lblDuration.backgroundColor = AppColor.white.withAlphaComponent(0.6)
        lblDuration.layer.cornerRadius = 20
        lblDuration.layer.masksToBounds = true
        
        imgThumbnail.layer.cornerRadius = 12
        imgThumbnail.superview?.layer.cornerRadius = 12
        
        btnMore.setImage(R.image.ic_more_circle()?.withRenderingMode(.alwaysTemplate),
                         for: .normal)
        btnMore.tintColor = AppColor.white.withAlphaComponent(0.6)
    }
    
    func setFont() {
        lblDuration.font = AppFont.getFont(style: .headline, weight: .medium)
    }
    
    func configData(data: ECVideo) {
        imgPlay.image = UIImage(systemName: "play.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imgPlay.tintColor = AppColor.white.withAlphaComponent(0.6)
        imgThumbnail.image = data.thumImage?.image
        lblDuration.text = " \(data.duration) "
    }
    
    func configData(data: ECPhoto) {
        imgThumbnail.image = data.thumImage?.image
    }
    
    @IBAction func btnMoreSelected(_ sender: UIButton) {
        actionDelegate?.btnMoreSelected(fromCell: self, viaSender: sender)
    }
}
