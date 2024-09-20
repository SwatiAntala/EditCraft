//
//  Premium.swift
//  EditCraft
//
//  Created by swati on 09/09/24.
//

import UIKit

enum Premium: Int, CaseIterable {
    case yearly
    case monthly
    case weekly
    
    var title: String {
        switch self {
        case .yearly:
            return R.string.localizable.payYearly()
        case .monthly:
            return R.string.localizable.payMonthly()
        case .weekly:
            return R.string.localizable.payWeekly()
        }
    }
    
    var subTitle: String {
        switch self {
        case .yearly:
            return R.string.localizable.moneySave()
        case .monthly:
            return R.string.localizable.bestPopular()
        case .weekly:
            return R.string.localizable.regular()
        }
    }
    
    var body: String {
        switch self {
        case .yearly:
            return R.string.localizable.yearly()
        case .monthly:
            return R.string.localizable.monthly()
        case .weekly:
            return R.string.localizable.weekly()
        }
    }
    
    var subImage: UIImage {
        switch self {
        case .yearly:
            return R.image.ic_restore_yearly()!
        case .monthly:
            return R.image.ic_restore_monthly()!
        case .weekly:
            return R.image.ic_restore_weekly()!
        }
    }
    
    var image: UIImage {
        switch self {
        case .yearly:
            return R.image.ic_yearly()!
        case .monthly:
            return R.image.ic_monthly()!
        case .weekly:
            return R.image.ic_weekly()!
        }
    }
    
    var color: UIColor {
        switch self {
        case .yearly:
            return AppColor.PremiumText.yearly
        case .monthly:
            return AppColor.PremiumText.monthly
        case .weekly:
            return AppColor.PremiumText.weekly
        }
    }
    
    func getPrice() -> String {
        switch self {
        case .weekly:
            return IAPManager.shared.weekLocalizedPrice
        case .monthly:
            return IAPManager.shared.monthLocalizedPrice
        case .yearly:
            return IAPManager.shared.yearLocalizedPrice
        }
    }
    
    func getInAppID() -> String {
        switch self {
        case .weekly:
            return Config.Week_ID
        case .monthly:
            return Config.Month_ID
        case .yearly:
            return Config.Year_ID
        }
    }
    
    
    func getInAppType() -> String { // using for API call
        switch self {
        case .weekly:
            return "WEEK"
        case .monthly:
            return "MONTH"
        case .yearly:
            return "YEAR"
        }
    }
    
    func getInAppPrice() -> String { // using for API call
        switch self {
        case .weekly:
            return AppData.sharedInstance.strWeek
        case .monthly:
            return AppData.sharedInstance.strMonth
        case .yearly:
            return AppData.sharedInstance.strYear
        }
    }
}
