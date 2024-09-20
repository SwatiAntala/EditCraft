//
//  Setting.swift
//  EditCraft
//
//  Created by swati on 09/09/24.
//

import Foundation
import UIKit

enum Setting: Int, CaseIterable {
    case shareApp
    case rateApp
    case privacyPolicy
    case term
    case contactUs
    
    var title: String {
        switch self {
        case .shareApp:
            return R.string.localizable.shareApp()
        case .rateApp:
            return R.string.localizable.rateApp()
        case .privacyPolicy:
            return R.string.localizable.privacyPolicy()
        case .term:
            return R.string.localizable.termsCondition()
        case .contactUs:
            return R.string.localizable.contactUs()
        }
    }
    
    var subTitle: String {
        switch self {
        case .shareApp:
            return R.string.localizable.shareApp1()
        case .rateApp:
            return R.string.localizable.rateApp1()
        case .privacyPolicy:
            return R.string.localizable.privacyPolicy1()
        case .term:
            return R.string.localizable.termsCondition1()
        case .contactUs:
            return R.string.localizable.contactUs1()
        }
    }
    
    var image: UIImage {
        switch self {
        case .shareApp:
            return R.image.ic_share()!
        case .rateApp:
            return R.image.ic_rate_app()!
        case .privacyPolicy:
            return R.image.ic_privacy_policy()!
        case .term:
            return R.image.ic_term_condition()!
        case .contactUs:
            return R.image.ic_contact_us()!
        }
    }
}
