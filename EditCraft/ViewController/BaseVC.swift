//
//  BaseVC.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//

import UIKit

class BaseVC: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private var lastNotificationDateKey: Bool {
        return UserDefaults.standard.object(forKey: "lastNotificationDateKey") == nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        setNavigationAppearance()
    }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func setNavigationAppearance() {
        let yourBackImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        
        let btnBack = ECButton()
        btnBack.setImage(R.image.ic_back(), for: .normal)
        setConstaint(btnBack, constant: 32)
        btnBack.addTarget(self, action: #selector(btnBackSelected),
                          for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        
        let attr = [
            NSAttributedString.Key.foregroundColor: AppColor.white,
            NSAttributedString.Key.font: AppFont.getFont(style: .body,
                                                         weight: .bold) as Any
        ]
        
        appearance.titleTextAttributes = attr
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @objc func btnBackSelected() {
        coordinator?.navigationController.popViewController(animated: true)
    }
}
