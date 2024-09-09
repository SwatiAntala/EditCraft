//
//  PickAudio.swift
//  EditCraft
//
//  Created by swati on 07/09/24.
//

import UIKit

enum PickAudio: Int, CaseIterable {
    case appleMusic
    case fileManager
    case recordAudio
    
    var image: UIImage {
        switch self {
        case .appleMusic:
            return (R.image.ic_apple_music()?.withRenderingMode(.alwaysTemplate))!
        case .fileManager:
            return (R.image.ic_file_manager()?.withRenderingMode(.alwaysTemplate))!
        case .recordAudio:
            return (R.image.ic_record_audio()?.withRenderingMode(.alwaysTemplate))!
        }
    }
    
    var title: String {
        switch self {
        case .appleMusic:
            return R.string.localizable.appleMusic()
        case .fileManager:
            return R.string.localizable.fileManager()
        case .recordAudio:
            return R.string.localizable.recordAudio()
        }
    }
}
