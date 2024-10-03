//
//  EditAudioCollectionViewCell.swift
//  EditCraft
//
//  Created by swati on 07/09/24.
//

import UIKit

protocol EditAudioCellDelegate: AnyObject {
    func btnMoreSelected(fromCell cell: EditAudioCollectionViewCell, viaSender sender: UIButton)
    func btnPlaySelected(fromCell cell: EditAudioCollectionViewCell, viaSender sender: UIButton)
}

class EditAudioCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    weak var actionDelegate: EditAudioCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI() {
        setColor()
        setFont()
        setImage()
    }
    
    func setColor() {
        if let superview = imgView.superview {
            superview.layer.cornerRadius = cornerRadius
            superview.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        }
        imgView.layer.cornerRadius = 40
        
        lblTitle.textColor = AppColor.white
        lblSubTitle.textColor = AppColor.deselect
    }
    
    func setFont() {
        lblTitle.font = AppFont.getFont(style: .title2, weight: .medium)
        lblSubTitle.font = AppFont.getFont(style: .body)
    }
    
    func setImage() {
        btnMore.setImage(R.image.ic_menu()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnPlay.setImage(R.image.ic_play()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnPlay.setImage(R.image.ic_pause()?.withRenderingMode(.alwaysTemplate), for: .selected)
        [btnMore, btnPlay].forEach { btn in
            btn?.tintColor = AppColor.theme
        }
    }

    @IBAction func btnPlaySelected(_ sender: UIButton) {
        actionDelegate?.btnPlaySelected(fromCell: self, viaSender: sender)
    }
    
    @IBAction func btnMoreSelected(_ sender: UIButton) {
        actionDelegate?.btnMoreSelected(fromCell: self, viaSender: sender)
    }
    
    func configData(data: ECAudio) {
        lblTitle.text = data.name
        lblSubTitle.text = "Size: \(data.size)  Duration: \(data.duration)"
        imgView.image = data.thumImage?.image
    }
}
