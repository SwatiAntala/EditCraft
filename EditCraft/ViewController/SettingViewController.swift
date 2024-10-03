//
//  SettingViewController.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import UIKit
import MessageUI

class SettingViewController: BaseVC {
    
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    @IBOutlet weak var lblHeader3: UILabel!
    
    @IBOutlet weak var viewShareApp: SettingView!
    @IBOutlet weak var viewRateApp: SettingView!
    
    @IBOutlet weak var viewPrivacyPolicy: SettingView!
    @IBOutlet weak var viewTermCondition: SettingView!
    
    @IBOutlet weak var viewContactUs: SettingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        setHeader()
        setView()
        setFont()
    }
    
    func setFont() {
        [lblHeader1, lblHeader2, lblHeader3].forEach { lbl in
            lbl?.font = AppFont.getFont(style: .title1, weight: .medium)
            lbl?.textColor = AppColor.Text.secondary
        }
    }
    
    func setHeader() {
        lblHeader1.text = R.string.localizable.promoteApp()
        lblHeader2.text = R.string.localizable.lawful()
        lblHeader3.text = R.string.localizable.help()
    }
    
    func setView() {
        [viewShareApp, viewRateApp,
         viewPrivacyPolicy, viewTermCondition,
         viewContactUs].forEach { view in
            view?.setUI()
            view?.actionDelegate = self
        }
        
        viewShareApp.configData(data: Setting.shareApp)
        viewRateApp.configData(data: Setting.rateApp)
        
        viewPrivacyPolicy.configData(data: Setting.privacyPolicy)
        viewTermCondition.configData(data: Setting.term)
        
        viewContactUs.configData(data: Setting.contactUs)
        
        [viewShareApp.superview, viewPrivacyPolicy.superview, viewContactUs.superview].forEach { view in
            view?.layer.cornerRadius = 16
            view?.backgroundColor = AppColor.background
        }
    }
}

extension SettingViewController: SettingViewDelegate {
    func viewTapped(viaSender sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? SettingView else { return }
        
        // Example: Perform specific actions based on the tapped view
        if tappedView == viewShareApp {
            shareApp()
        } else if tappedView == viewRateApp {
            coordinator?.redirectRating()
        } else if tappedView == viewPrivacyPolicy {
            coordinator?.redirectWebView(url: AppData.sharedInstance.strPrivacyPolicy,
                                         screenTitle: R.string.localizable.privacyPolicy())
        } else if tappedView == viewTermCondition {
            coordinator?.redirectWebView(url: AppData.sharedInstance.strTermCondition,
                                         screenTitle: R.string.localizable.termsCondition())
        } else if tappedView == viewContactUs {
            sendEmail()
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
        activityViewController.popoverPresentationController?.sourceView = self.viewShareApp

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
