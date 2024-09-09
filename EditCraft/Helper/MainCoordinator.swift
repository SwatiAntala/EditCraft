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
}
