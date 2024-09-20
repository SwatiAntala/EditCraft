//
//  RateAppService.swift
//  VideoIt
//
//  Created by swati on 16/06/24.
//

import Foundation
import UIKit
import StoreKit

final class RateAppService {
    
    private init() {  }
    
    class func requestReview() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview(in: windowScene)
        } else {
            if let url = URL(string: APP_LINK) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
