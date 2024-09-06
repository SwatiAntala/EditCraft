//
//  ECVideo.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import Foundation

struct ECVideo: Codable {
    var id = UUID()
    var url: String = ""
    var thumImage: Data?
    var assetIdentifier: String = ""
    var duration: String = ""
}
