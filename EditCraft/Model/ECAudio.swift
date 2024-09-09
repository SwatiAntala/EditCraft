//
//  ECAudio.swift
//  EditCraft
//
//  Created by swati on 07/09/24.
//

import Foundation

struct ECAudio: Codable {
    var id = UUID()
    var audioURL: String = ""
    var thumImage: Data?
    var duration: String = ""
    var name: String = ""
    var size: String = ""
}
