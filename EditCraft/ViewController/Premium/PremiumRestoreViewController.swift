//
//  PremiumRestoreViewController.swift
//  EditCraft
//
//  Created by swati on 10/09/24.
//

import UIKit
import MBProgressHUD

class PremiumRestoreViewController: BaseVC {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgPremium: UIImageView!
    @IBOutlet weak var lblEditCraft: UILabel!
    @IBOutlet weak var lblUnlock: UILabel!
    @IBOutlet weak var lblYouAreUsing: UILabel!
    @IBOutlet weak var lblActive: UILabel!
    
    @IBOutlet weak var lblPayFor: UILabel!
    @IBOutlet weak var imgPlan: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblLaunchDateText: UILabel!
    @IBOutlet weak var lblLaunchDate: UILabel!
    @IBOutlet weak var lblDeadLineDateText: UILabel!
    @IBOutlet weak var lblDeadLineDate: UILabel!
    @IBOutlet weak var lblYouAreUsingProVersion: UILabel!
    @IBOutlet weak var btnRestore: ECButton!
    var premium: Premium = .yearly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        setColor()
        setFont()
        setDateForPremium()
        setData()
        setImage()
    }
    
    func setImage() {
        imgPremium.image = R.image.img_premium()
        imgPlan.image = premium.subImage
        btnClose.setImage(R.image.ic_close()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnClose.tintColor = AppColor.white
    }
    
    func setColor() {
        lblEditCraft.textColor = AppColor.white
        lblUnlock.textColor = AppColor.themeSecondary
        lblYouAreUsing.textColor = AppColor.theme
        lblActive.textColor = AppColor.white
        lblPayFor.textColor = AppColor.themeSecondary
        lblPrice.textColor = AppColor.white
        lblLaunchDateText.textColor = AppColor.themeSecondary
        lblDeadLineDateText.textColor = AppColor.themeSecondary
        lblLaunchDate.textColor = AppColor.white
        lblDeadLineDate.textColor = AppColor.white
        lblYouAreUsingProVersion.textColor = AppColor.destructive
        
        if let superView = lblPayFor.superview {
            superView.layer.cornerRadius = cornerRadius
            superView.backgroundColor = AppColor.theme
        }
        
        if let superView = lblLaunchDateText.superview?.superview {
            superView.layer.cornerRadius = cornerRadius
            superView.backgroundColor = AppColor.themeTertiary.withAlphaComponent(0.8)
        }
        
        btnRestore.setAsPrimary()
    }
    
    func setFont() {
        lblEditCraft.font = AppFont.getFont(style: .title1, weight: .bold)
        lblUnlock.font = AppFont.getFont(style: .title1, weight: .bold)
        lblYouAreUsing.font = AppFont.getFont(style: .title2, weight: .bold)
        lblActive.font = AppFont.getFont(style: .title2, weight: .medium)
        
        lblPayFor.font = AppFont.getFont(style: .title2, weight: .bold)
        lblPrice.font = AppFont.getFont(style: .title2, weight: .bold)
        
        [lblLaunchDateText, lblDeadLineDateText,
         lblLaunchDate, lblDeadLineDate].forEach { lbl in
            lbl?.font = AppFont.getFont(style: .title2, weight: .bold)
        }
        
        lblYouAreUsingProVersion.font = AppFont.getFont(style: .title2, weight: .bold)
    }
    
    func setData() {
        lblEditCraft.text = R.string.localizable.editCraft()
        lblUnlock.text = R.string.localizable.unlock()
        lblYouAreUsing.text = R.string.localizable.youAreUsingTheHighQualityVersion()
        lblActive.text = R.string.localizable.activeSubscriptionStatus()
        lblPayFor.text = R.string.localizable.payFor(premium.body)
        lblPrice.text = R.string.localizable.per(premium.getPrice(), premium.title.localizedUppercase)
        lblLaunchDateText.text = R.string.localizable.launchDate()
        lblDeadLineDateText.text = R.string.localizable.deadlineDate()
        lblYouAreUsingProVersion.text = R.string.localizable.ifYouReUsingTheProVersion()
        btnRestore.setTitle(R.string.localizable.restore(), for: .normal)
        lblLaunchDate.text = AppData.sharedInstance.inappCommencementDate.toString()
        lblDeadLineDate.text = AppData.sharedInstance.inappExpireDate.toString()
    }
    
    func setDateForPremium() {
        if AppData.sharedInstance.inappID == Config.Week_ID {
            premium = .weekly
        } else if AppData.sharedInstance.inappID == Config.Month_ID {
            premium = .monthly
        } else if AppData.sharedInstance.inappID == Config.Year_ID {
            premium = .yearly
        }
    }
    
    @IBAction func btnCloseSelected(_ sender: UIButton) {
        coordinator?.navigationController.popViewController(animated: true)
    }
    
    @IBAction func btnRestoreSelelcted(_ sender: UIButton) {
        if InternetConnectionManager.isConnectedToNetwork() {
            if AppData.sharedInstance.strInAppWork == "YES" {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                IAPManager.init().doRestore(self) { (success, error) in
                    DispatchQueue.main.async(execute: {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if success {
                            let okAction = UIAlertAction(title: R.string.localizable.oK(), style: .default) { _ in
                                if let vcs = self.coordinator?.navigationController.viewControllers {
                                    if let loginVC = vcs.first(where: {$0 is TabbarViewController}) {
                                        self.coordinator?.navigationController.popToViewController(loginVC,
                                                                                                   animated: true)
                                    }
                                }
                            }
                            self.showAlert(title: R.string.localizable.congrates().uppercased(),
                                           message: R.string.localizable.restoredSuccessfully(),
                                           actions: [okAction])
                        } else {
                            self.showAlert(title: R.string.localizable.error(),
                                      message: error)
                        }
                    })
                }
            } else {
                showAlert(title: R.string.localizable.underMaintanance().uppercased(),
                          message: R.string.localizable.weAreWorkingToFixItPleaseTryAgainLater())
            }
        } else {
            showAlert(title: "",
                      message: R.string.localizable.noInternetConnection())
        }
    }
}
