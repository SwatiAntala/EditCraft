//
//  StartViewController.swift
//  TikSaver
//
//  Created by iMac on 06/07/23.
//

import UIKit
import StoreKit
import SwiftyStoreKit

//MARK: In-App IDs

let isProductionMode = INAPP_MODE // 0 = Debug, 1 = Live

struct InAppValidationKeys {
    static let production = AppleReceiptValidator(service: isProductionMode ? .production : .sandbox, sharedSecret: INAPP_SHARED_SECRET)
}

enum IAPUserDefaultsKeys: String {
    
    case weekPrice
    case monthPrice
    case yearPrice
    
    case weekLocalizedPrice
    case monthLocalizedPrice
    case yearLocalizedPrice
    
    case weekFreeTrial
    case monthFreeTrial
    case yearFreeTrial
    
}

//Subscription Types
enum SalesSubscriptionType: String {
    case month = "1"
    case half = "2"
    case year = "3"
}


class IAPManager: NSObject {
    
    static let shared = IAPManager()
    fileprivate let uDefaults = UserDefaults.standard
    
    //    var isPurchased : Bool {
    //        get {
    //            return UserDefaults.standard.bool(forKey: "isPurchased")
    //        }
    //    }
    
    var weekPrice: Double {
        get {
            let value = uDefaults.double(forKey: IAPUserDefaultsKeys.weekPrice.rawValue)
            return value == 0.0 ? 6.99 : value
        }
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.weekPrice.rawValue)
        }
    }
    
    var monthPrice: Double {
        get {
            let value = uDefaults.double(forKey: IAPUserDefaultsKeys.monthPrice.rawValue)
            return value == 0.0 ? 11.99 : value
        }
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.monthPrice.rawValue)
        }
    }
    
    var yearPrice: Double {
        get {
            let value = uDefaults.double(forKey: IAPUserDefaultsKeys.yearPrice.rawValue)
            return value == 0.0 ? 19.99 : value
        }
        
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.yearPrice.rawValue)
        }
    }
    
    var weekLocalizedPrice: String {
        get {
            return uDefaults.string(forKey: IAPUserDefaultsKeys.weekLocalizedPrice.rawValue) ?? "$6.99"
        }
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.weekLocalizedPrice.rawValue)
        }
    }
    
    var monthLocalizedPrice: String {
        get {
            return uDefaults.string(forKey: IAPUserDefaultsKeys.monthLocalizedPrice.rawValue) ?? "$11.99"
        }
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.monthLocalizedPrice.rawValue)
        }
    }
    
    var yearLocalizedPrice: String {
        get {
            return uDefaults.string(forKey: IAPUserDefaultsKeys.yearLocalizedPrice.rawValue) ?? "$19.99"
        }
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.yearLocalizedPrice.rawValue)
        }
    }
    
    var weekFreeTrial: String {
        get {
            return uDefaults.string(forKey: IAPUserDefaultsKeys.weekFreeTrial.rawValue) ?? ""
            //            return uDefaults.string(forKey: IAPUserDefaultsKeys.monthFreeTrial.rawValue) ?? "2 Days Free Trial"
        }
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.weekFreeTrial.rawValue)
        }
    }
    
    var monthFreeTrial: String {
        get {
            return uDefaults.string(forKey: IAPUserDefaultsKeys.monthFreeTrial.rawValue) ?? ""
            //            return uDefaults.string(forKey: IAPUserDefaultsKeys.halfFreeTrial.rawValue) ?? "2 Days Free Trial"
        }
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.monthFreeTrial.rawValue)
        }
    }
    
    var yearFreeTrial: String {
        get {
            return uDefaults.string(forKey: IAPUserDefaultsKeys.yearFreeTrial.rawValue) ?? ""
            //            return uDefaults.string(forKey: IAPUserDefaultsKeys.yearFreeTrial.rawValue) ?? "3 Days Free Trial"
        }
        set(newValue) {
            uDefaults.set(newValue, forKey: IAPUserDefaultsKeys.yearFreeTrial.rawValue)
        }
    }
    
    override init() {
        super.init()
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    
                    //                    print("Purchaseeeee")
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    
                    if Config.arrSubscription.contains(purchase.productId) {
                        //                        print("Purchaseeeee", purchase.productId)
                        // if purchase.productId == Config.Lifetime_ID {
                        //     self.verifyLifetimeReceipt(productId: Config.Lifetime_ID) { (_, _) in }
                        // } else {
                        self.verifyReceipt(productIds: Config.arrSubscription) { (_, _) in }
                        // }
                    }
                }
            }
        }
    }
    
    func retrivePricing() {
        
        SwiftyStoreKit.retrieveProductsInfo(Config.arrSubscription) { (results) in
            for product in results.retrievedProducts {
                let proudctId = product.productIdentifier
                let price = product.localizedPrice
                if proudctId == Config.Week_ID {
                    self.weekLocalizedPrice = price!
                    self.weekPrice = Double(truncating: product.price)
                    if #available(iOS 11.2, *), let subscription = product.introductoryPrice?.subscriptionPeriod {
                        let freeTrial = subscription.numberOfUnits
                        self.weekFreeTrial = String.init(format: "Free for %d %@", freeTrial, self.getText(forSubscription: subscription))
                    }
                    debugPrint("\(proudctId) \(self.weekLocalizedPrice) - \(self.weekPrice) - \(self.weekFreeTrial)")
                    continue
                }
                if proudctId == Config.Month_ID {
                    self.monthLocalizedPrice = price!
                    self.monthPrice = Double(truncating: product.price)
                    if #available(iOS 11.2, *), let subscription = product.introductoryPrice?.subscriptionPeriod {
                        let freeTrial = subscription.numberOfUnits
                        self.monthFreeTrial = String.init(format: "Free for %d %@", freeTrial, self.getText(forSubscription: subscription))
                    }
                    debugPrint("\(proudctId) \(self.monthLocalizedPrice) - \(self.monthPrice) - \(self.monthFreeTrial)")
                    continue
                }
                if proudctId == Config.Year_ID {
                    self.yearLocalizedPrice = price!
                    self.yearPrice = Double(truncating: product.price)
                    if #available(iOS 11.2, *), let subscription = product.introductoryPrice?.subscriptionPeriod {
                        let freeTrial = subscription.numberOfUnits
                        self.yearFreeTrial = String.init(format: "Free for %d %@", freeTrial, self.getText(forSubscription: subscription))
                    }
                    debugPrint("\(proudctId) \(self.yearLocalizedPrice) - \(self.yearPrice) - \(self.yearFreeTrial)")
                    continue
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name.init("PriceChanged"), object: nil)
        }
    }
    
    @available(iOS 11.2, *)
    fileprivate func getText(forSubscription subs: SKProductSubscriptionPeriod) -> String {
        switch subs.unit {
        case SKProduct.PeriodUnit.day:
            return "Day"
        case SKProduct.PeriodUnit.week:
            return subs.numberOfUnits > 1 ? "Weeks" : "Week"
        case SKProduct.PeriodUnit.month:
            return subs.numberOfUnits > 1 ? "Months" : "Month"
        case SKProduct.PeriodUnit.year:
            return subs.numberOfUnits > 1 ? "Years" : "Year"
        default:
            return ""
        }
    }
    
    func doPurchase(_ forController:UIViewController, _ productId:String, _ completion:@escaping(_ success:Bool,_ error:String)->Void) {
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                //if Config.Lifetime_ID == productId {
                //completion(true, "")
                //   self.verifyLifetimeReceipt(productId: productId) { success, reason in
                //      completion(success,reason)
                //   }
                // } else {
                self.verifyReceipt(productIds: [productId], { (success, reason) in
                    completion(success,reason)
                })
                // }
            } else {
                if case .error(let er) = result {
                    let code = (er as NSError).code
                    if code == SKError.Code.paymentCancelled.rawValue {
                        completion(false, "Cancelled")
                    } else {
                        completion(false, er.localizedDescription)
                    }
                }
            }
        }
    }
    
    func doRestore(_ forController:UIViewController, _ completion:@escaping(_ success:Bool, _ error:String) -> ()) {
        //if Helper.shared().isConnectedToInternet() {
        //SwiftLoader.show(animated: true)
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoredPurchases.count > 0 {
                
                var isLifetime : Bool = false
                
                for product in results.restoredPurchases {
                    
                    if product.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                    
                   // if product.productId == Config.Lifetime_ID {
                   //     isLifetime = true
                  //  } /*else {
                    //   isLifetime = true
                   //    }*/
                }
                
//                if isLifetime {
//                    //completion(true,"")
//                    self.verifyLifetimeReceipt(productId: Config.Lifetime_ID) { success, reason in
//                        completion(success,reason)
//                    }
//                } else {
                    self.verifyReceipt(productIds: Config.arrSubscription, { (success, reason) in
                        //SwiftLoader.hide()
                        completion(success,reason)
                    })
                //}
                
            } else if let failedResult = results.restoreFailedPurchases.first {
                //SwiftLoader.hide()
                completion(false, failedResult.0.localizedDescription)
            } else {
                completion(false,"You do not have any active subscription to restore. Please subscribe to a plan to use the features & services.")
            }
        }
        //}
    }
    
    func verifyReceipt(productIds : Set<String>,_ completion:@escaping(_ success:Bool,_ error:String)->Void){
        //if Helper.shared().isConnectedToInternet() {
        SwiftyStoreKit.verifyReceipt(using: InAppValidationKeys.production) { result in
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    AppData.sharedInstance.inappExpireDate = expiryDate
                    for item in items {
                        if Config.arrSubscription.contains(item.productId) {
                            //                            print("\(item.productId) are valid until \(String(describing: item.subscriptionExpirationDate))\n\(items)\n")
                            AppData.sharedInstance.inappStatus = "Active"
                            AppData.sharedInstance.inappID = item.productId
                            AppData.sharedInstance.inappCommencementDate = item.purchaseDate
                            Config.setPurchased(isPurchased: true)
                            AppData.sharedInstance.isPaid = true
                            //                            completion(true,"Purchased")
                            //                            return
                        }
                    }
                    completion(true,"purchased")
                    //                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    AppData.sharedInstance.inappExpireDate = expiryDate
                    for item in items {
                        if Config.arrSubscription.contains(item.productId) {
                            //                            AppData.sharedInstance.inappStatus = "Expired"
                            //                            AppData.sharedInstance.inappID = item.productId
                            Config.setPurchased(isPurchased: false)
                            AppData.sharedInstance.isPaid = false
                        }
                    }
                    completion(false,"expired")
                    //                    debugPrint("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    completion(false,"notPurchased")
                    //                    print("The user has never purchased \(productIds)")
                    Config.setPurchased(isPurchased: false)
                    AppData.sharedInstance.isPaid = false
                }
            case .error(let error):
                completion(false,error.localizedDescription)
                //                debugPrint("Receipt verification failed: \(error)")
                Config.setPurchased(isPurchased: false)
                AppData.sharedInstance.isPaid = false
            }
            //SwiftLoader.hide()
        }
    }
    //}
    
    func verifyLifetimeReceipt(productId : String,_ completion:@escaping(_ success:Bool,_ error:String)->Void){
        //if Helper.shared().isConnectedToInternet() {
        SwiftyStoreKit.verifyReceipt(using: InAppValidationKeys.production) { result in
            switch result {
            case .success(let receipt):
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productId, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                    AppData.sharedInstance.inappID = productId
                    AppData.sharedInstance.isPaid = true
                    Config.setPurchased(isPurchased: true)
                    completion(true,"purchased")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    //                        AppData.sharedInstance.isPaid = false
                    //                        Config.setPurchased(isPurchased: false)
                    //completion(false,"notPurchased")
                    completion(false,"You never purchased any PRO plan. Please subscribe to a plan to use the features & services.")
                }
            case .error(let error):
                //                    Config.setPurchased(isPurchased: false)
                //                    AppData.sharedInstance.isPaid = false
                completion(false,error.localizedDescription)
                //                debugPrint("Receipt verification failed: \(error)")
            }
            //SwiftLoader.hide()
        }
    }
}

