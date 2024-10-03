//
//  SpecialOfferViewController.swift
//  DualSpace
//
//  Created by swati on 11/08/24.
//

import UIKit
import MBProgressHUD
import Alamofire
 
class SpecialOfferViewController: BaseVC {
    
    @IBOutlet weak var lblSpecialOffer: UILabel!
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var lblExpiresIn: UILabel!
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDayText: UILabel!
    @IBOutlet weak var lblCollon1: UILabel!
    
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblHoursText: UILabel!
    @IBOutlet weak var lblCollon2: UILabel!
    
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMinText: UILabel!
    @IBOutlet weak var lblCollon3: UILabel!
    
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblSecText: UILabel!
    
    @IBOutlet weak var lblRegularPriceText: UILabel!
    @IBOutlet weak var lblRegularPrice: UILabel!
    
    @IBOutlet weak var lblOfferPriceText: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var btnClaimNow: ECButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var img50Percentage: UIImageView!
    @IBOutlet weak var lblPercentage: UILabel!
    
    @IBOutlet weak var btnSeeRegularPlan: UIButton!
    
    var selectedPlan = Premium.weekly
    var isFromNotification: Bool = false
    
    private var isFirstLaunch: Bool {
        return UserDefaults.standard.object(forKey: "endDate") == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPremiumOption()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        CountdownTimer.shared.loadTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CountdownTimer.shared.saveTimer()
    }
    
    func setPremiumOption() {
        let offerType = AppData.sharedInstance.offerInAppType.lowercased()

        if offerType == "w" {
            selectedPlan = .weekly
        } else if offerType == "m" {
            selectedPlan = .monthly
        } else if offerType == "y" {
            selectedPlan = .yearly
        }
    }
    
    func setUI() {
        setImage()
        setColor()
        setFont()
        setData()
        setTimer()
        btnClaimNow.setAsBordered()
        flash()
    }
    
    func setImage() {
        imgTop.image = R.image.img_offer()
        btnClose.setImage(R.image.ic_close()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnClose.tintColor = AppColor.white
    }
    
    func setColor() {
        lblExpiresIn.textColor = AppColor.white
        
        [lblDay, lblHours, lblMin, lblSec].forEach { lbl in
            lbl?.textColor = AppColor.theme
            lbl?.font = AppFont.getFont(style: .title1, weight: .bold)
        }
        
        [lblDayText, lblHoursText, lblMinText, lblSecText].forEach { lbl in
            lbl?.textColor = AppColor.Text.secondary
            lbl?.font = AppFont.getFont(style: .body, weight: .medium)
        }
        
        lblRegularPrice.textColor = AppColor.white
        lblRegularPrice.textColor = .red
        
        lblOfferPriceText.textColor = AppColor.white
        lblOfferPrice.textColor = AppColor.theme
        
        if let superView = lblExpiresIn.superview {
            superView.layer.cornerRadius = cornerRadius
            superView.backgroundColor = AppColor.background
        }
        lblSpecialOffer.textColor = AppColor.white
        btnSeeRegularPlan.setTitleColor(AppColor.Text.secondary, for: .normal)
    }
    
    func setFont() {
        lblExpiresIn.font = AppFont.getFont(style: .title2, weight: .medium)
        lblRegularPriceText.font = AppFont.getFont(style: .title2, weight: .medium)
        lblRegularPrice.font = AppFont.getFont(style: .title2, weight: .medium)
        lblOfferPriceText.font = AppFont.getFont(style: .title1, weight: .semibold)
        lblOfferPrice.font = AppFont.getFont(style: .largeTitle, size: 50, weight: .bold)
        lblSpecialOffer.font = AppFont.getFont(style: .title1, weight: .bold)
        btnSeeRegularPlan.titleLabel?.font = AppFont.getFont(style: .title3, weight: .medium)
    }
    
    func setData() {
        lblExpiresIn.text = R.string.localizable.expiresIn()
        
        lblDayText.text = R.string.localizable.day()
        lblHoursText.text = R.string.localizable.hrs()
        lblMinText.text = R.string.localizable.min()
        lblSecText.text = R.string.localizable.sec()
        
        lblRegularPriceText.text = R.string.localizable.regularPrice()
        lblOfferPriceText.text = R.string.localizable.offerPrice()
        
        // regular price = (discount) / (1 - percentage / 100)
        
        let discountPrice = Double(selectedPlan.getInAppPrice()) ?? 0.0
        let percentage = Double(AppData.sharedInstance.offerInAppPercentage) ?? 0.0
        let decimal = 1 - (percentage/100.0)
        
        let regularPrice = discountPrice/decimal
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        let result = selectedPlan.getPrice().getAmountAndSymbol()
        let symbol = result.symbol
        
        lblRegularPrice.attributedText = formatPrice(regularPrice, with: symbol).strikeThrough()
        lblOfferPrice.text = selectedPlan.getPrice()
        btnClaimNow.setTitle(R.string.localizable.claimNow().uppercased(), for: .normal)
        lblSpecialOffer.text = R.string.localizable.specialOffer()
        btnSeeRegularPlan.setTitle(R.string.localizable.seeRegularPlan(), for: .normal)
    }
    
    func formatPrice(_ price: Double, with symbol: String) -> String {
        return String(format: "\(symbol)%.2f", price)
    }
    
    func setTimer() {
        CountdownTimer.shared.setLabels(daysLabel: lblDay,
                                        hoursLabel: lblHours,
                                        minutesLabel: lblMin,
                                        secondsLabel: lblSec) {
            MTUserDefaults.specialOffer = 0
            MTUserDefaults.isSpecialOfferFinished = true
            self.coordinator?.navigationController.popViewController(animated: true)
        }
        
        if isFirstLaunch {
            let time = Double(AppData.sharedInstance.offerInAppTime)
            CountdownTimer.shared.setTime(time: "\(time ?? .zero)") {
                MTUserDefaults.specialOffer = 0
                MTUserDefaults.isSpecialOfferFinished = true
                self.coordinator?.navigationController.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func btnCloseSelected(_ sender: Any) {
        if isFromNotification {
            if let vcs = self.coordinator?.navigationController.viewControllers {
                if let loginVC = vcs.first(where: {$0 is TabbarViewController}) {
                    self.coordinator?.navigationController.popToViewController(loginVC,
                                                                               animated: true)
                } else {
                    coordinator?.redirectTab()
                }
            } else {
                coordinator?.redirectTab()
            }
        } else {
            coordinator?.navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func btnClaimNowSelected(_ sender: UIButton) {
        btnClaimNow.layer.removeAllAnimations()
        if AppData.sharedInstance.inAppWork {
            if InternetConnectionManager.isConnectedToNetwork() {
                if AppData.sharedInstance.strInAppWork == "YES" {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    IAPManager.init().doPurchase(self, selectedPlan.getInAppID()) { (success, error) in
                        DispatchQueue.main.async(execute: {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if success {
                                let okAction = UIAlertAction(title: R.string.localizable.oK(),
                                                             style: .default) { _ in
                                    self.inAppApi()
                                    self.redirectionHandle()
                                }
                                self.showAlert(title: R.string.localizable.congrates().uppercased(),
                                               message: R.string.localizable.upgradedSuccessfully(),
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
        } else {
            showAlert(title: R.string.localizable.editCraft(),
                      message: R.string.localizable.weApologizeForTheInconvenience())
        }
    }
    
    @IBAction func btnSeeRegularPlanSelected(_ sender: UIButton) {
        coordinator?.redirectPremium()
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.8
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = .infinity
        btnClaimNow.layer.add(flash, forKey: nil)
    }
}

extension SpecialOfferViewController {
    func inAppApi() {

        let para : Parameters = [
            "api_key": API_Key,
            "package_name" : APP_IDENTIFIER,
            "inapp_plan" : selectedPlan.getInAppType(),
            "inapp_amount" : selectedPlan.getInAppPrice()
        ]
        
        //        print(para)
        
        AF.request(updateInappService_URL,
                   method: .post,
                   parameters: para,
                   headers: nil).responseString { res in
        }
    }
    
    func redirectionHandle() {
        if let vcs = self.coordinator?.navigationController.viewControllers {
            if let loginVC = vcs.first(where: {$0 is TabbarViewController}) {
                self.coordinator?.navigationController.popToViewController(loginVC,
                                                                           animated: true)
            } else {
                coordinator?.redirectTab()
            }
        } else {
            coordinator?.redirectTab()
        }
    }
}
