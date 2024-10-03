//
//  OptiToast.swift
//  VideoEditor
//
//  Created by Optisol on 21/07/19.
//  Copyright © 2019 optisol. All rights reserved.
//


import Foundation
import UIKit
import Toast

class OptiToast {
    
    class private func showAlert(backgroundColor:UIColor, textColor:UIColor, message:String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let mainCoordinator = sceneDelegate.mainCoordinator else { return }
        
        var style = ToastStyle()
        style.backgroundColor = AppColor.white.withAlphaComponent(0.5)
        style.messageFont = AppFont.getFont(style: .title2, weight: .bold)!
        mainCoordinator.navigationController.visibleViewController?.view.makeToast(message,
                                                                                   position: .top,
                                                                                   style: style)
    }
    
    class func showPositiveMessage(message:String) {
        showAlert(backgroundColor: UIColor.green, textColor: UIColor.white, message: message)
    }
    
    class func showNegativeMessage(message:String) {
        showAlert(backgroundColor: UIColor.red, textColor: UIColor.white, message: message)
    }
}
