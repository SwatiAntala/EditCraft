//
//  TabItem.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//

import UIKit

enum TabItem: Int, CaseIterable {
    case videoEdit
    case photoEdit
    case audioEdit
    case setting
    
    
    func getImage() -> UIImage? {
        switch self {
        case .videoEdit:
            return R.image.ic_edit_video()
        case .photoEdit:
            return R.image.ic_edit_photo()
        case .audioEdit:
            return R.image.ic_edit_audio()
        case .setting:
            return R.image.ic_setting()
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .videoEdit:
            return R.string.localizable.video()
        case .photoEdit:
            return R.string.localizable.photo()
        case .audioEdit:
            return R.string.localizable.audio()
        case .setting:
            return R.string.localizable.setting()
        }
    }
}
