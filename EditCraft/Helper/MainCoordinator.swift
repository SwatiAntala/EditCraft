//
//  MainCoordinator.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//

import Foundation
import UIKit
import StoreKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var message: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //Splsh  --> Language  -> Intro  -> Home
    func start() {
        if let vc = R.storyboard.main.splashVC() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func redirectIntroduction() {
        if let vc = R.storyboard.main.introVC() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectPremiumSelection() {
        if let vc = R.storyboard.premiumRestore.premiumSelectionVC() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectTab() {
        if let vc = R.storyboard.main.tabbarVC() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func redirectEditVideo() {
        if let vc = R.storyboard.video.optiVC() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectRecordAudio() {
        if let vc = R.storyboard.audio.recordViewController() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectTrimAudio(url: URL) {
        if let vc = R.storyboard.audio.trimAudioVC() {
            vc.coordinator = self
            vc.audioFileURL = url
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectPremium(isFromInitial: Bool = false) {
        if let vc = R.storyboard.premium.premiumVC() {
            vc.coordinator = self
            vc.isFromInitial = isFromInitial
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectPremiumRestore() {
        if let vc = R.storyboard.premiumRestore.premiumRestoreVC() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectSpecialOffer() {
        if let vc = R.storyboard.offer.specialOfferVC() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectWebView(url: String, screenTitle: String) {
        if let vc = R.storyboard.main.webVC() {
            vc.coordinator = self
            vc.url = url
            vc.screenTitle = screenTitle
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func redirectRating() {
        if let vc = R.storyboard.main.ratingVC() {
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
}
