//
//  RatingViewController.swift
//  VideoIt
//
//  Created by swati on 16/06/24.
//

import UIKit
import MessageUI

class RatingViewController: BaseVC {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewRating: StarRatingView!
    @IBOutlet weak var btnSubmit: ECButton!
    var ratingType: RateType = .feedback
    
    enum RateType {
        case feedback
        case rate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setUI() {
        setImage()
        setColor()
        setFont()
        setData()
        setRatingView()
        updateUI(rating: 0)
        btnSubmit.setAsPrimary()
    }
    
    func setRatingView() {
        viewRating.delegate = self
        viewRating.currentRating = 0 // Set initial rating
    }
    
    func setColor() {
        lblTitle.textColor = AppColor.white
        lblSubTitle.textColor = AppColor.white
        btnClose.setImage(R.image.ic_close()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnClose.tintColor = AppColor.white
    }
    
    func setFont() {
        lblTitle.font = AppFont.getFont(style: .title3, weight: .bold)
        lblSubTitle.font = AppFont.getFont(style: .body)
    }
    
    func setData() {
        lblTitle.text = R.string.localizable.youropinionmatterstouS()
        lblSubTitle.text = R.string.localizable.weWorkSuperHardToServeYouBetter()
        btnSubmit.setTitle(R.string.localizable.rateNow(), for: .normal)
    }
    
    func setImage() {
        imgBg.image = R.image.img_rate_app()
    }
    
    @objc func btnCloseSelected() {
        coordinator?.navigationController.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitSelected(_ sender: UIButton) {
        switch ratingType {
        case .feedback:
            sendEmail()
        case .rate:
            RateAppService.requestReview()
        }
        
        func sendEmail() {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([AppData.sharedInstance.strFeedBackEmail])
                mail.setSubject("")
                var message = ""
                mail.setMessageBody(message, isHTML: false)
                present(mail, animated: true)
            } else {
                // show failure alert
            }
        }
    }
    
    @IBAction func btnCloseSelected(_ sender: UIButton) {
        coordinator?.navigationController.popViewController(animated: true)
    }
    
}

extension RatingViewController: StarRatingDelegate {
    func didChangeRating(_ rating: Int) {
        updateUI(rating: rating)
    }
    
    func updateUI(rating: Int) {
        if rating <= 3 { // show feed back view
            btnSubmit.setTitle(R.string.localizable.rateNow(), for: .normal)
            ratingType = .feedback
        } else { // add rate
            btnSubmit.setTitle(R.string.localizable.rateNow(), for: .normal)
            ratingType = .rate
        }
        view.layoutIfNeeded()
    }
}


extension RatingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}
