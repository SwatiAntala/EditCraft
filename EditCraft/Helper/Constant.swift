//
//  Constant.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import UIKit

let cornerRadius = 6.0

struct AudioFile: Hashable {
    let id: UUID
    let url: URL
}

var audioFiles: [AudioFile] = []

// Function to fetch audio file URLs from the app's document directory
func fetchFromFileManager(vimixed: ECAudio) -> AudioFile? {
    let fileManager = FileManager.default
    guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    do {
        let audioFilesURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
        
        audioFiles = audioFilesURLs
            .map { AudioFile(id: vimixed.id, url: $0) }
        
        guard let videoURL = URL(string: vimixed.audioURL) else { return nil }
        if let index = audioFiles.firstIndex(where: {$0.url.lastPathComponent == videoURL.lastPathComponent}) {
            return audioFiles[index]
        } else {
            return nil
        }
    } catch {
        return nil
    }
}

func setConstaint(_ view: UIView, constant: CGFloat = 35) {
    let widthConstraint1 = view.widthAnchor.constraint(equalToConstant: constant)
    let heightConstraint1 = view.heightAnchor.constraint(equalToConstant: constant)
    heightConstraint1.isActive = true
    widthConstraint1.isActive = true
}
