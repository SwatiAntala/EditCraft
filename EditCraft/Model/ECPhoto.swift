//
//  ECPhoto.swift
//  EditCraft
//
//  Created by swati on 06/09/24.
//

import Foundation

struct ECPhoto: Codable {
    var id = UUID()
    var thumImage: Data?
    var assetIdentifier: String = ""
}
