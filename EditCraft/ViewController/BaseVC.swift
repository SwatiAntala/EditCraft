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
    }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
}
