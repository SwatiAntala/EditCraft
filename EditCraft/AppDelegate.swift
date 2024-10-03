//
//  AppDelegate.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Alamofire
import SDWebImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if Config.isPurchase() {
            AppData.sharedInstance.isPaid = true
        } else {
            AppData.sharedInstance.isPaid = false
        }
        
        IAPManager.shared.retrivePricing()
        
        IAPManager.shared.verifyReceipt(productIds: Config.arrSubscription) { success, error in
            if success {
                print("success")
            } else {
                print(error)
            }
        }
        
        // for interestial ads
        let yesterday = Date().dayBefore
        UserDefaults.standard.set(yesterday, forKey: "time_DemoApp")
        UserDefaults.standard.synchronize()
        
        // ASSIGN DEFAULT VALUES (IF ERROR IN API THEN DEFAULT WILL WORK)
        AppData.sharedInstance.isFullscreenAdOpen = false
        AppData.sharedInstance.strIntrestialAdID = INTERESTIAL_AD_ID
        AppData.sharedInstance.strOpenAdID = OPEN_AD_ID
        AppData.sharedInstance.strNativeAdID = NATIVE_AD_ID
        AppData.sharedInstance.strBannerAdID = BANNER_AD_ID
        AppData.sharedInstance.currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        AppData.sharedInstance.newVersion = NEW_VERSION
        
        // Get app data from api
        if (UserDefaults.standard.object(forKey: "Dual_AppData") == nil) {
            getAppData()
        } else {
            if let dicData = (UserDefaults.standard.object(forKey: "Dual_AppData") as! NSDictionary).mutableCopy() as? NSMutableDictionary {
                if dicData != [:] {
                    setAppData(dic: dicData)
                }
                getAppData()
            } else {
                getAppData()
            }
        }
        
//        // OneSignal initialization
//          OneSignal.initialize(ONESIGNAL_APP_ID, withLaunchOptions: launchOptions)
//
//          // requestPermission will show the native iOS notification permission prompt.
//          // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//          OneSignal.Notifications.requestPermission({ accepted in
//            print("User accepted notifications: \(accepted)")
//          }, fallbackToSettings: true)
//
          // Login your customer with externalId
          // OneSignal.login("EXTERNAL_ID")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarConfiguration.previousNextDisplayMode = .alwaysHide
        
        if AppData.sharedInstance.isPaid == false {
            if MTUserDefaults.isSpecialOfferFinished {
                MTUserDefaults.specialOffer = 0
            }
            else if Int(AppData.sharedInstance.offerInAppCounter) == MTUserDefaults.specialOffer {
                MTUserDefaults.specialOffer = 1
            } else {
                MTUserDefaults.specialOffer += 1
            }
        } else {
            MTUserDefaults.specialOffer = 0
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EditCraft")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func getAppData() {
        
        var isDown : String = "NO"
        
        if (UserDefaults.standard.object(forKey: "install_Demo") == nil) {
            isDown = "NO"
            UserDefaults.standard.set("yes", forKey: "install_Demo")
            UserDefaults.standard.synchronize()
        } else {
            let str = UserDefaults.standard.object(forKey: "install_Demo") as! String
            if str == "yes" {
                isDown = "YES"
            } else {
                isDown = "NO"
            }
        }
        
        let para : Parameters = [
            "api_key": API_Key,
            "package_name" : APP_IDENTIFIER,
            "is_downloaded" : isDown
        ]
        
        AF.request(initializeService_URL,
                   method: .post,
                   parameters: para,
                   headers: nil)
        .responseString { res in
            
            if((res.value) != nil) {
                
                //print(res.value!)
                
                let str = res.value!
                
                let data = str.data(using: .utf8)!
                
                do {
                    
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> {
                        
                        let dic = (jsonArray as NSDictionary).mutableCopy() as! NSMutableDictionary
                        //print(dic)
                        
                        var dicData: NSMutableDictionary = [:]
                        if (dic["data"] != nil) {// start
                            
                            dicData = (dic["data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            
                            self.setAppData(dic: dicData)
                        } // end
                        
                    } else {
                        //print("bad json")
                    }
                    
                } catch _ as NSError {
                    //print(error)
                }
            }
        }
    }
}


extension AppDelegate {
    func setAppData(dic: NSMutableDictionary) {
        
        if (dic["is_update"] != nil) {
            if dic["is_update"] as! String == "NO" {
                AppData.sharedInstance.isShowUpdate = false
            } else {
                AppData.sharedInstance.isShowUpdate = true
            }
        }
        
        if (dic["is_adscreen_active"] != nil) {
            if dic["is_adscreen_active"] as! String == "NO" {
                AppData.sharedInstance.isOtherAppAd = false
            } else {
                AppData.sharedInstance.isOtherAppAd = true
            }
        }
        
        if (dic["isNativeShow"] != nil) {
            if dic["isNativeShow"] as! String == "NO" {
                AppData.sharedInstance.strNativeShow = "NO" //native ad nae aave
            } else {
                AppData.sharedInstance.strNativeShow = "YES" //native ad aavse
            }
        }
        
        if (dic["isBannerShow"] != nil) {
            if dic["isBannerShow"] as! String == "NO" {
                AppData.sharedInstance.strBannerShow = "NO" //banner ad nae aave
            } else {
                AppData.sharedInstance.strBannerShow = "YES" //banner ad aavse
            }
        }
        
        if (dic["isIntrestialShow"] != nil) {
            if dic["isIntrestialShow"] as! String == "NO" {
                AppData.sharedInstance.strIntrestialShow = "NO" //inrestial ad nae aave
            } else {
                AppData.sharedInstance.strIntrestialShow = "YES" //inrestial ad aavse
            }
        }
        
        if (dic["isOpenShow"] != nil) {
            if dic["isOpenShow"] as! String == "NO" {
                AppData.sharedInstance.strOpenShow = "NO" //open ad nae aave
            } else {
                AppData.sharedInstance.strOpenShow = "YES" //open ad aavse
            }
        }
        
        if (dic["inAppAfterIntro"] != nil) {
            if dic["inAppAfterIntro"] as! String == "NO" {
                AppData.sharedInstance.inAppAfterIntro = false
            } else {
                AppData.sharedInstance.inAppAfterIntro = true
            }
        }
        
        if (dic["inAppOnStart"] != nil) {
            if dic["inAppOnStart"] as! String == "NO" {
                AppData.sharedInstance.inAppOnStart = false
            } else {
                AppData.sharedInstance.inAppOnStart = true
            }
        }
        
        if (dic["inAppWork"] != nil) {
            if dic["inAppWork"] as! String == "NO" {
                AppData.sharedInstance.inAppWork = false
            } else {
                AppData.sharedInstance.inAppWork = true
            }
        }
    
        if (dic["app_version"] != nil) {
            AppData.sharedInstance.newVersion = dic["app_version"] as! String
        }
        
        if (dic["ad_gap"] != nil) {
            AppData.sharedInstance.adGap = dic["ad_gap"] as! String
        }
        
        if (dic["strWeek"] != nil) {
            AppData.sharedInstance.strWeek = dic["strWeek"] as! String
        }
        
        if (dic["strMonth"] != nil) {
            AppData.sharedInstance.strMonth = dic["strMonth"] as! String
        }
        
        if (dic["strYear"] != nil) {
            AppData.sharedInstance.strYear = dic["strYear"] as! String
        }
        
        if (dic["feedbackEmail"] != nil) {
            AppData.sharedInstance.strFeedBackEmail = dic["feedbackEmail"] as! String
        }
        
        if (dic["contactUs"] != nil) {
            AppData.sharedInstance.contactUsEmail = dic["contactUs"] as! String
        }
        
        if (dic["privacy_policy"] != nil) {
            AppData.sharedInstance.strPrivacyPolicy = dic["privacy_policy"] as! String
        }
        
        if (dic["terms_condition"] != nil) {
            AppData.sharedInstance.strTermCondition = dic["terms_condition"] as! String
        }
        
        if (dic["ratingShowCount"] != nil) {
            AppData.sharedInstance.strRatingShowCount = dic["ratingShowCount"] as! String
        }
    
        if (dic["userAgent"] != nil) {
            AppData.sharedInstance.userAgent = dic["userAgent"] as! String
        }
        
        if (dic["offerInApp"] != nil) {
            AppData.sharedInstance.offerInApp = dic["offerInApp"] as! String
        }
        
        if (dic["offerInAppTime"] != nil) {
            AppData.sharedInstance.offerInAppTime = dic["offerInAppTime"] as! String
        }
        
        if (dic["offerInAppCounter"] != nil) {
            AppData.sharedInstance.offerInAppCounter = dic["offerInAppCounter"] as! String
        }
        
        if (dic["offerInAppPercentage"] != nil) {
            AppData.sharedInstance.offerInAppPercentage = dic["offerInAppPercentage"] as! String
        }
        
        if (dic["offerInAppType"] != nil) {
            AppData.sharedInstance.offerInAppType = dic["offerInAppType"] as! String
        }
        
        if (dic["introInAppType"] != nil) {
            AppData.sharedInstance.introInAppType = dic["introInAppType"] as! String
        }
        
        if (dic["isLocalNotification"] != nil) {
            if dic["isLocalNotification"] as! String == "NO" {
                AppData.sharedInstance.isLocalNotification = false
            } else {
                AppData.sharedInstance.isLocalNotification = true
            }
        }
        
        if (dic["localNotificationCounter"] != nil) {
            AppData.sharedInstance.localNotificationCounter = dic["localNotificationCounter"] as! String
        }
        
        if (dic["isOfferInAppNotification"] != nil) {
            if dic["isOfferInAppNotification"] as! String == "NO" {
                AppData.sharedInstance.isOfferInAppNotification = false
            } else {
                AppData.sharedInstance.isOfferInAppNotification = true
            }
        }
        
        if (dic["offerInAppNotificationCounter"] != nil) {
            AppData.sharedInstance.offerInAppNotificationCounter = dic["offerInAppNotificationCounter"] as! String
        }
        
        if (dic["offerNotificationTitle"] != nil) {
            AppData.sharedInstance.offerNotificationTitle = dic["offerNotificationTitle"] as! String
        }
        
        if (dic["offerNotificationSubTitle"] != nil) {
            AppData.sharedInstance.offerNotificationSubTitle = dic["offerNotificationSubTitle"] as! String
        }
        
        
        if (dic["is_admob_active"] != nil) {
            
            if dic["is_admob_active"] as! String == "YES" {
                
                AppData.sharedInstance.isAdmobAd = dic["is_admob_active"] as! String
                
                if (dic["admob_interstial_ad_id"] != nil) {
                    if dic["admob_interstial_ad_id"] as! String == "" {
                        AppData.sharedInstance.strIntrestialAdID = INTERESTIAL_AD_ID
                    } else {
                        AppData.sharedInstance.strIntrestialAdID = dic["admob_interstial_ad_id"] as! String
                    }
                }
                
                if (dic["admob_app_open_ad_id"] != nil) {
                    if dic["admob_app_open_ad_id"] as! String == "" {
                        AppData.sharedInstance.strOpenAdID = OPEN_AD_ID
                    } else {
                        AppData.sharedInstance.strOpenAdID = dic["admob_app_open_ad_id"] as! String
                    }
                }
                
                if (dic["admob_native_ad_id"] != nil) {
                    if dic["admob_native_ad_id"] as! String == "" {
                        AppData.sharedInstance.strNativeAdID = NATIVE_AD_ID
                    } else {
                        AppData.sharedInstance.strNativeAdID = dic["admob_native_ad_id"] as! String
                    }
                }
                
                if (dic["admob_banner_ad_id"] != nil) {
                    if dic["admob_banner_ad_id"] as! String == "" {
                        AppData.sharedInstance.strBannerAdID = BANNER_AD_ID
                    } else {
                        AppData.sharedInstance.strBannerAdID = dic["admob_banner_ad_id"] as! String
                    }
                }
                
            } else {
                
                AppData.sharedInstance.isAdmobAd = "NO"
                AppData.sharedInstance.strIntrestialAdID = INTERESTIAL_AD_ID
                AppData.sharedInstance.strOpenAdID = OPEN_AD_ID
                AppData.sharedInstance.strNativeAdID = NATIVE_AD_ID
                AppData.sharedInstance.strBannerAdID = BANNER_AD_ID
                
            }
            
        } else {
            AppData.sharedInstance.isAdmobAd = "NO"
            AppData.sharedInstance.strIntrestialAdID = INTERESTIAL_AD_ID
            AppData.sharedInstance.strOpenAdID = OPEN_AD_ID
            AppData.sharedInstance.strNativeAdID = NATIVE_AD_ID
            AppData.sharedInstance.strBannerAdID = BANNER_AD_ID
        }
        
        AppData.sharedInstance.dicMain = dic
        
        UserDefaults.standard.set(AppData.sharedInstance.dicMain, forKey: "Dual_AppData")
        UserDefaults.standard.synchronize()
    }
}
