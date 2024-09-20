//
//  AppData.swift
//  VideoIt
//
//  Created by swati on 16/06/24.
//


import Foundation

struct SharedData {
    
    var dicMain : NSMutableDictionary = [:]
    
    var strOpenShow : String = "YES";// YES : open ad aavse === NO : open ad nae aave
    var strIntrestialShow : String = "YES";// YES : intrestial ad aavse === NO : intrestial ad nae aave
    var strNativeShow : String = "YES"; // YES : native ad aavse === NO : native ad nae aave
    var strBannerShow : String = "YES"; // YES : banner ad aavse === NO : banner ad nae aave
    
    var strIntrestialAdID : String = "";
    var strOpenAdID : String = "";
    var strNativeAdID : String = "";
    var strBannerAdID : String = "";
    
    var isShowUpdate : Bool = false;
    var isOtherAppAd : Bool = false;
    var currentVersion : String = "" ;
    var newVersion : String = "" ;
    
    var isAdmobAd : String = "YES" ;
    var adGap : String = "0.3" ;
    
    var isFullscreenAdOpen : Bool = false;
    
    // IN-APP
    var inappID : String = "";
    var inappStatus : String = "";
    var inappExpireDate : Date = Date();
    var inappCommencementDate : Date = Date();
    var isPaid : Bool = false;
    var strWeek : String = "6.99";
    var strMonth : String = "11.99";
    var strYear : String = "19.99";
    var strInAppWork : String = "YES";
    
    var contactUsEmail: String = "";
    var strFeedBackEmail : String = "";
    var strTermCondition : String = "";
    var strPrivacyPolicy: String = "";
    var strRatingShowCount: String = "";
    var userAgent: String = ""
    
    var inAppAfterIntro: Bool = true;
    var inAppOnStart: Bool = true;
    var inAppWork: Bool = true;
    
    var offerInApp: String = "";
    var offerInAppTime: String = "";
    var offerInAppCounter: String = "";
    var offerInAppPercentage: String = "";
    var offerInAppType: String = "";
    
    var introInAppType: String = "";
    
    var isLocalNotification: Bool = false;
    var localNotificationCounter: String = "";
    var isOfferInAppNotification: Bool = false;
    var offerInAppNotificationCounter: String = "";
    var offerNotificationTitle: String = "";
    var offerNotificationSubTitle: String = "";
}

class AppData {
    static var sharedInstance : SharedData = SharedData();
}
