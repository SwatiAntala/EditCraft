//
//  AppFont.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import Foundation
import UIKit

enum AppFont {
    
    static func getFont(style: UIFont.TextStyle,
                              weight: UIFont.Weight = .regular) -> UIFont? {
        var fontName = ""
        
        switch weight {
            case .bold: fontName = R.file.robotoBoldTtf.name
            case .regular: fontName = R.file.robotoRegularTtf.name
            case .medium: fontName = R.file.robotoMediumTtf.name
            default: break
        }
        
        var descriptor = UIFontDescriptor(name: fontName, size: UIFont.preferredFont(forTextStyle: style).pointSize)
        descriptor = descriptor.addingAttributes([UIFontDescriptor.AttributeName.traits:
                                                    [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: descriptor, size: UIFont.preferredFont(forTextStyle: style).pointSize)
    }
    
}
