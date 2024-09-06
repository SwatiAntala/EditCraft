//
//  Coordinator.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//

import Foundation
import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
