//
//  MTUserDefaults.swift
//  VideoIt
//
//  Created by swati on 25/04/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct MTUserDefaults {
    static func removeAllData() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    
    @UserDefault(Key.UserDefaults.kIsOnBoardingCompleted, defaultValue: false)
    static var isOnBoardingCompleted: Bool

    
    @UserDefault(Key.UserDefaults.kSpecialOffer, defaultValue: 0)
    static var specialOffer: Int
    
    @UserDefault(Key.UserDefaults.kSpecialOfferFinished, defaultValue: false)
    static var isSpecialOfferFinished: Bool
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    return encoder
}

