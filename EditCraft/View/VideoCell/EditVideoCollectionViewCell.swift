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
    
    func setColor() {
        lblDuration.textColor = AppColor.black
        lblDuration.backgroundColor = AppColor.white.withAlphaComponent(0.6)
        lblDuration.layer.cornerRadius = 12
        lblDuration.layer.masksToBounds = true
        
        imgThumbnail.layer.cornerRadius = 12
        imgThumbnail.superview?.layer.cornerRadius = 12
        
        btnMore.setImage(UIImage(systemName: "ellipsis.circle.fill")?.withRenderingMode(.alwaysTemplate),
                         for: .normal)
        btnMore.tintColor = AppColor.white.withAlphaComponent(0.6)
    }
    
    func setFont() {
        lblDuration.font = AppFont.getFont(style: .footnote, weight: .medium)
    }
    
    func configData(data: ECVideo) {
        imgPlay.image = UIImage(systemName: "play.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imgPlay.tintColor = AppColor.white.withAlphaComponent(0.6)
        imgThumbnail.image = data.thumImage?.image
        lblDuration.text = " \(data.duration) "
    }
    
    @IBAction func btnMoreSelected(_ sender: UIButton) {
        actionDelegate?.btnMoreSelected(fromCell: self, viaSender: sender)
    }
}
