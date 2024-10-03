//
//  SplashViewController.swift
//  DualSpace
//
//  Created by swati on 11/08/24.
//

import UIKit
import GoogleMobileAds

class SplashViewController: BaseVC {
    
    @IBOutlet weak var imgView: UIImageView!
    
    private var isMobileAdsStartCalled = false
    var secondsRemaining: Int = 5
    var countdownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startTimer()
        initializeAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if AppData.sharedInstance.isFullscreenAdOpen == false {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    //MARK: Other Method
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(decrementCounter),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func decrementCounter() {
        secondsRemaining -= 1
        guard secondsRemaining <= 0 else {
            return
        }
        countdownTimer?.invalidate()
        
        if AppData.sharedInstance.isPaid == false && AppData.sharedInstance.isAdmobAd == "YES" && AppData.sharedInstance.isFullscreenAdOpen == false && AppData.sharedInstance.strOpenShow == "YES" {
            AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
        } else {
            startMainScreen()
        }
    }
    
    func startMainScreen() {
        if MTUserDefaults.isOnBoardingCompleted {
            if AppData.sharedInstance.isPaid != true, AppData.sharedInstance.inAppOnStart {
                coordinator?.redirectPremium(isFromInitial: true)
            } else {
                coordinator?.redirectTab()
            }
        } else {
            coordinator?.redirectIntroduction()
        }
    }
}

extension SplashViewController {
    func initializeAds() {
        if AppData.sharedInstance.isPaid == false {
            AppOpenAdManager.shared.appOpenAdManagerDelegate = self
            GoogleMobileAdsConsentManager.shared.gatherConsent(from: self) {
                [weak self] consentError in
                guard let self else { return }
                
                if let consentError {
                    // Consent gathering failed.
                    //print("Error: \(consentError.localizedDescription)")
                    self.startGoogleMobileAdsSDK()
                    return
                }
                
                if GoogleMobileAdsConsentManager.shared.canRequestAds {
                    self.startGoogleMobileAdsSDK()
                }
                
                // Move onto the main screen if the app is done loading.
                if self.secondsRemaining <= 0 {
                    self.startMainScreen()
                }
            }
            
            // This sample attempts to load ads using consent obtained in the previous session.
            if GoogleMobileAdsConsentManager.shared.canRequestAds {
                startGoogleMobileAdsSDK()
            }
        }
    }
}

extension SplashViewController {
    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }
            self.isMobileAdsStartCalled = true
            // Initialize the Google Mobile Ads SDK.
            GADMobileAds.sharedInstance().start()
            
            if AppData.sharedInstance.isPaid == false && AppData.sharedInstance.isAdmobAd == "YES" {
                
                if AppData.sharedInstance.strOpenShow == "YES" {
                    AppOpenAdManager.shared.loadAd()
                }
                
                if AppData.sharedInstance.strIntrestialShow == "YES" {
                    AdmobManager.shared.requestAds()
                }
            }
        }
    }
}

extension SplashViewController: AppOpenAdManagerDelegate {
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager) {
        if let vc = coordinator?.navigationController.visibleViewController {
            if vc is Self {
                startMainScreen()
            }
        }
    }
}
