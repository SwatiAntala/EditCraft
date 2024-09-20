//
//  AdmobManager.swift
//  WhtasWeb
//
//  Created by CATALINA on 11/09/20.
//  Copyright © 2020 MehulKathiriya. All rights reserved.
//

import Foundation
import GoogleMobileAds

enum HomeNavigation: String {
    case premium
    case tab
}

class AdmobManager : NSObject, GADFullScreenContentDelegate {
    
    static let shared = AdmobManager()
    
    var interstitialAd: GADInterstitialAd?
    var vc : UIViewController?
    var strType: HomeNavigation?
    
    var total : Int = 0
    var kUserDefault = UserDefaults.standard
    
    func requestAds() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:AppData.sharedInstance.strIntrestialAdID,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                //print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
        }
        )
    }
    
    func showAds(vw : UIViewController, str: HomeNavigation?)  {
        
        vc = vw
        strType = str
        
        
        var isShowAd : Bool = false
        
        if (UserDefaults.standard.object(forKey: "time_DemoApp") == nil) {
            
            UserDefaults.standard.set(Date(), forKey: "time_DemoApp")
            UserDefaults.standard.synchronize()
            isShowAd = true
            
        } else {
            
            let startDate = UserDefaults.standard.object(forKey: "time_DemoApp") as! Date
            //            print("start = \(startDate)")
            let endDate = Date()
            //            print("end = \(endDate)")
            let differenceInSeconds = Int(endDate.timeIntervalSince(startDate))
            //            print("Second = \(differenceInSeconds)")
            
            if Double(differenceInSeconds) >= (Double(AppData.sharedInstance.adGap)! * 60.0) {
                isShowAd = true
            } else {
                isShowAd = false
            }
            
            //            if Double(differenceInSeconds) >= 60.0 {
            //                isShowAd = true
            //            } else {
            //                isShowAd = false
            //            }
            
            // if you want to show ad compulsory, then ad condition for that type
            if strType?.rawValue == "" || strType?.rawValue == "" {
                isShowAd = true
            }
        }
        
        if isShowAd == true {
            if interstitialAd != nil {
                interstitialAd?.present(fromRootViewController: vw)
                UserDefaults.standard.set(Date(), forKey: "time_DemoApp")
                UserDefaults.standard.synchronize()
                AppData.sharedInstance.isFullscreenAdOpen = true
            } else {
                common()
            }
        } else {
            common()
        }
        
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        common()
        //print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad presented full screen content.
    //    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    //       //print("Ad did present full screen content.")
    //    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        common()
        //print("Ad did dismiss full screen content.")
    }
    
    //    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
    //       common()
    //    }
    //
    //    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
    //        common()
    //    }
    
    func common() {
        AppData.sharedInstance.isFullscreenAdOpen = false
        if strType == .premium {
            let v = vc as! PremiumViewController
            v.sendToAdmob(str: strType ?? .premium)
        }
        else {
            let v = vc as! TabbarViewController
            v.sendToAdmob(str: strType ?? .tab)
        }
    }
}
