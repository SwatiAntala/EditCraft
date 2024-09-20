//
//  Introduction.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//

import Foundation
import UIKit

enum Introduction: Int, CaseIterable {
    
    case editVideo
    case editPhoto
    case editAudio
    
    
    func getTitle() -> String {
        switch self {
        case .editVideo:
            return R.string.localizable.introTitle1()
        case .editPhoto:
            return R.string.localizable.introTitle2()
        case .editAudio:
            return R.string.localizable.introTitle3()
        }
    }
    
    func getSubTitle() -> String {
        switch self {
        case .editVideo:
            return R.string.localizable.introSubTitle1()
        case .editPhoto:
            return R.string.localizable.introSubTitle2()
        case .editAudio:
            return R.string.localizable.introSubTitle3()
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .editVideo:
            return R.image.ic_intro_1()
        case .editPhoto:
            return R.image.ic_intro_2()
        case .editAudio:
            return R.image.ic_intro_3()
        }
    }
    
    func getButtonTitle() -> String? {
        switch self {
        case .editVideo:
            return R.string.localizable.next()
        case .editPhoto:
            return R.string.localizable.next()
        case .editAudio:
            return R.string.localizable.done()
        }
    }
}
