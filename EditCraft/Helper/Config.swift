//
//  Config.swift
//  VideoIt
//
//  Created by swati on 16/06/24.
//

import Foundation

import Foundation

struct Config {
    
    private init() {
        
    }
    
    static let Week_ID = "com.ktn.weekly"
    static let Month_ID = "com.ktn.monthly"
    static let Year_ID = "com.ktn.yearly"
    static let arrSubscription = Set(arrayLiteral: Week_ID, Month_ID, Year_ID)
    static let isPurchasedKey = "Dual_IsPaid"
    
    static func isPurchase() -> Bool {
        return UserDefaults.standard.bool(forKey: Config.isPurchasedKey)
    }
    
    static func setPurchased(isPurchased : Bool) {
        UserDefaults.standard.set(isPurchased, forKey: Config.isPurchasedKey)
    }
}

let APP_IDENTIFIER = "com.swati.parallalspace" // set app identifier
let API_Key = "ABCD&123@45L*KJH%G98765"


// TEST ID
let NATIVE_AD_ID = "ca-app-pub-3940256099942544/3986624511"
let BANNER_AD_ID = "ca-app-pub-3940256099942544/2934735716"
let INTERESTIAL_AD_ID = "ca-app-pub-3940256099942544/4411468910"
let OPEN_AD_ID = "ca-app-pub-3940256099942544/5575463023"


let NEW_VERSION = "1.0" // set new app version you are going to upload on store.
let INAPP_MODE = false // true = live || false = sandbox
let INAPP_SHARED_SECRET = "294671f830c243cbab219db6a8db2ed3" // set shared secret key (you find it from app store connect)


let google_URL = "https://www.google.com"
let initializeService_URL = "https://developer.loopinfosol.com/api_services/initialize_service.php"
let updateInappService_URL = "https://developer.loopinfosol.com/api_services/update_inapp_service.php"


let APP_ID = "1579857563" // set your app id
let APP_LINK = "https://itunes.apple.com/app/id\(APP_ID)"
let ONESIGNAL_APP_ID = "39443e14-171b-4350-9a56-20a9f5a6de3c"
let CLIENT_ID = "43075244171-t2uvv41k1rgmcith379lo4jru26p9kum.apps.googleusercontent.com"
let DROPBOX_APP_KEY = "1bhdls3evo7t4sc"
