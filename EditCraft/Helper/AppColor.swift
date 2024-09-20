//
//  AppColor.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import Foundation

enum AppColor {
    static let theme = R.color.theme()!
    static let themeSecondary = R.color.themeSecondary()!
    static let themeTertiary = R.color.themeTertiary()!
    static let background = R.color.background()!
    static let backgroundSecondary = R.color.backgroundSecondary()!
    static let black = R.color.black()!
    static let white = R.color.white()!
    static let deselect = R.color.deselect()!
    static let destructive = R.color.destructive()!
    
    enum Text {
        static let secondary = R.color.textSecondary()!
    }
    
    enum PremiumText {
        static let yearly = R.color.theme()!
        static let monthly = R.color.premiumSecond()!
        static let weekly = R.color.premiumThird()!
    }
}
