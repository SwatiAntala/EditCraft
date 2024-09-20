//
//  SettingViewController.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import UIKit
import MessageUI
import LocalAuthentication
import GoogleMobileAds

class SettingViewController: BaseVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblTimeSaving: UILabel!
    @IBOutlet weak var lblProFeature: UILabel!
    
    @IBOutlet weak var imgDualMsg: UIImageView!
    @IBOutlet weak var lblDualMsg: UILabel!
    
    @IBOutlet weak var imgClickToChat: UIImageView!
    @IBOutlet weak var lblClickToChat: UILabel!
    
    @IBOutlet weak var imgProfileViewer: UIImageView!
    @IBOutlet weak var lblProViewer: UILabel!
    
    @IBOutlet weak var imgNoAds: UIImageView!
    @IBOutlet weak var lblNoAds: UILabel!
    
    @IBOutlet weak var btnEnableNow: WMButton!
    
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    @IBOutlet weak var lblHeader3: UILabel!
    
    @IBOutlet weak var viewPasteAutomatically: SettingView!
    @IBOutlet weak var viewPrivacyLocker: SettingView!
    @IBOutlet weak var viewLanguage: SettingView!
    @IBOutlet weak var viewShareApp: SettingView!
    @IBOutlet weak var viewRateApp: SettingView!
    
    @IBOutlet weak var viewPrivacyPolicy: SettingView!
    @IBOutlet weak var viewTermCondition: SettingView!
    
    @IBOutlet weak var viewContactUs: SettingView!
    
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var stackIndicatorView: UIStackView!
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize:GADAdSizeFromCGSize(CGSize(width: viewBanner.frame.size.width,
                                                                           height: viewBanner.frame.size.height)))//GADBannerView(adSize:GADAdSizeMediumRectangle)
        adBannerView.adUnitID = AppData.sharedInstance.strBannerAdID
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        return adBannerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .languageDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AppData.sharedInstance.isFullscreenAdOpen == false {
            loadBannerAds()
        }
    }
    
    func setUI() {
        setHeader()
        setView()
        setFont()
        setImage()
        setData()
        setColor()
        setGesture()
        btnEnableNow.setAsBordered()
    }
    
    func setFont() {
        [lblHeader1, lblHeader2, lblHeader3].forEach { lbl in
            lbl?.font = AppFont.getFont(style: .body, weight: .medium)
            lbl?.textColor = AppColor.Text.secondary
        }
        
        [lblDualMsg, lblClickToChat, lblProViewer, lblNoAds].forEach { lbl in
            lbl?.font = AppFont.getFont(style: .caption1, weight: .medium)
            lbl?.textColor = AppColor.white
        }
        
        lblProFeature.font = AppFont.getFont(style: .title2, weight: .bold)
    }
    
    func setColor() {
        if let superView = imgDualMsg.superview?.superview?.superview {
            superView.backgroundColor = AppColor.backgroundSecondary
            superView.layer.cornerRadius = cornerRadius
        }
        
        if let superView = lblTimeSaving.superview {
            superView.backgroundColor = AppColor.background
            superView.layer.cornerRadius = cornerRadius
        }
        
        lblTimeSaving.textColor = AppColor.white
        lblProFeature.textColor = AppColor.theme
    }
    
    func setHeader() {
        lblHeader1.text = AppString.promoteApp.localizedString()
        lblHeader2.text = AppString.lawful.localizedString()
        lblHeader3.text = AppString.help.localizedString()
    }
    
    func setImage() {
        imgDualMsg.image = R.image.ic_s_dual_msg()
        imgClickToChat.image = R.image.ic_s_click_chat()
        imgProfileViewer.image = R.image.ic_s_profile_viewer()
        imgNoAds.image = R.image.ic_s_100_no_ads()
    }
    
    func setData() {
        lblTimeSaving.text = AppString.timeSaving.localizedString()
        lblProFeature.text = AppString.proFeatures.localizedString()
        lblDualMsg.text = AppString.dualMsg.localizedString()
        lblClickToChat.text = AppString.clickToChat.localizedString()
        lblProViewer.text = AppString.profileViewerSetting.localizedString()
        lblNoAds.text = AppString.noAds.localizedString()
        btnEnableNow.setTitle(AppString.enableNow.localizedString(), for: .normal)
    }
    
    func setView() {
        [viewPasteAutomatically, viewLanguage, viewShareApp, viewRateApp,
         viewPrivacyPolicy, viewTermCondition,
         viewContactUs, viewPrivacyLocker].forEach { view in
            view?.setUI()
            view?.actionDelegate = self
        }
        
        viewPasteAutomatically.configData(data: Setting.pasteAutomatically)
        viewPasteAutomatically.setPasteSwitch()
        
        viewPrivacyLocker.configData(data: Setting.locker)
        
        viewLanguage.configData(data: Setting.language)
        viewShareApp.configData(data: Setting.shareApp)
        viewRateApp.configData(data: Setting.rateApp)
        
        viewPrivacyPolicy.configData(data: Setting.privacyPolicy)
        viewTermCondition.configData(data: Setting.term)
        
        viewContactUs.configData(data: Setting.contactUs)
        
        [viewPasteAutomatically.superview, viewShareApp.superview,
         viewPrivacyPolicy.superview, viewContactUs.superview].forEach { view in
            view?.layer.cornerRadius = 16
            view?.backgroundColor = AppColor.background
        }
    }
    
    func setGesture() {
        let dualMsgGesture = UITapGestureRecognizer(target: self,
                                               action: #selector(btnDualMsgSelected))
        imgDualMsg.addGestureRecognizer(dualMsgGesture)
        
        let clickToChatGesture = UITapGestureRecognizer(target: self,
                                               action: #selector(btnClickToChatSelected))
        imgClickToChat.addGestureRecognizer(clickToChatGesture)
        
        let profileViewerGesture = UITapGestureRecognizer(target: self,
                                               action: #selector(btnProfileViewerSelected))
        imgProfileViewer.addGestureRecognizer(profileViewerGesture)
        
        let noAdsGesture = UITapGestureRecognizer(target: self,
                                               action: #selector(btnNoAdsSelected))
        imgNoAds.addGestureRecognizer(noAdsGesture)
    }
    
    // MARK: Banner Ads Method
    func loadBannerAds() {
        if AppData.sharedInstance.isPaid == false && AppData.sharedInstance.isAdmobAd == "YES" && AppData.sharedInstance.strBannerShow == "YES" {
            for view in viewBanner.subviews {
                view.removeFromSuperview()
            }
            viewBanner.isHidden = false
            self.adBannerView.load(GADRequest())
            adBannerView.frame = viewBanner.bounds
            adBannerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewBanner.addSubview(adBannerView)
            scrollView.contentInset.bottom = 80
        } else {
            stackIndicatorView.isHidden = true
            viewBanner.isHidden = true
            scrollView.contentInset.bottom = .zero
        }
    }
    
    @IBAction func btnEnableNowSelected(_ sender: UIButton) {
        
    }
    
    @objc func btnDualMsgSelected() {
        if let parent = self.parent as? TabbarViewController {
            parent.selectedIndexPath = IndexPath(item: 0, section: 0)
            if let vc = parent.dualAppVC {
                parent.setNavBar()
                parent.setScreen(baseVC: vc)
            }
        }
    }
    
    @objc func btnClickToChatSelected() {
        if let parent = self.parent as? TabbarViewController {
            parent.selectedIndexPath = IndexPath(item: 1, section: 0)
            if let vc = parent.directChatVC {
                parent.setScreen(baseVC: vc)
            }
        }
    }
    
    @objc func btnProfileViewerSelected() {
        if let parent = self.parent as? TabbarViewController {
            parent.selectedIndexPath = IndexPath(item: 2, section: 0)
            if let vc = parent.profileVC {
                parent.setScreen(baseVC: vc)
            }
        }
    }
    
    @objc func btnNoAdsSelected() {
        if AppData.sharedInstance.isPaid == true {
            coordinator?.redirectPremiumRestore()
        } else {
            if showOfferScreen {
                coordinator?.redirectSpecialOffer()
            } else {
                coordinator?.redirectPremium()
            }
        }
    }
}

extension SettingViewController: SettingViewDelegate {
    
    func switchPasteSelected(viaSender sender: UISwitch) {
        if sender.isOn {
            MTUserDefaults.isPasteAutomatically = true
        } else {
            MTUserDefaults.isPasteAutomatically = false
        }
    }
    
    func viewTapped(viaSender sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? SettingView else { return }
        
        // Example: Perform specific actions based on the tapped view
        if tappedView == viewShareApp {
            shareApp()
        } else if tappedView == viewRateApp {
            coordinator?.redirectRating()
        } else if tappedView == viewPrivacyPolicy {
            coordinator?.redirectcommonWebView(url: AppData.sharedInstance.strPrivacyPolicy,
                                         screenTitle: AppString.PrivacyPolicy.localizedString())
        } else if tappedView == viewTermCondition {
            coordinator?.redirectcommonWebView(url: AppData.sharedInstance.strTermCondition,
                                         screenTitle: AppString.termCondition.localizedString())
        } else if tappedView == viewContactUs {
            sendEmail()
        } else if tappedView == viewLanguage {
            coordinator?.redirectLanguages()
        } else if tappedView == viewPrivacyLocker {
            doLockUnlockApp { isSuccess in
                if isSuccess {
                    self.coordinator?.redirectLocker()
                } else {
                    self.showAlert(title: AppString.authenticationFailed.localizedString(),
                                   message: AppString.couldNotBeVerified.localizedString())
                }
            }
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([AppData.sharedInstance.contactUsEmail])
            mail.setSubject("")
            mail.setMessageBody("", isHTML: false)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func shareApp() {
        // Content to be shared
        guard let url = URL(string: APP_LINK) else { return }
        // Create an array of items to share
        let items = [url] as [Any]
        // Create an instance of UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // Exclude some sharing options (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        // Present the UIActivityViewController
        present(activityViewController, animated: true, completion: nil)
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
      controller.dismiss(animated: true)
    }
}

extension SettingViewController {
    func doLockUnlockApp(complition: @escaping(_ isSuccess: Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = AppString.identifyYourself.localizedString()
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        complition(true)
                    } else {
                        complition(false)
                    }
                }
            }
        } else {
            complition(false)
            showAlert(title: AppString.biometryUnavailable.localizedString(),
                      message: AppString.deviceNotConfiguredForBiometry.localizedString())
        }
    }
}

extension SettingViewController {
    @objc func updateUI() {
        setUI()
    }
}

extension SettingViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        stackIndicatorView.isHidden = true
    }
}
