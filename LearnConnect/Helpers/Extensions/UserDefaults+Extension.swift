//
//  UserDefaults+Extension.swift
//  LearnConnect
//
//  Created by Tural Babayev on 23.11.2024.
//

import Foundation

extension UserDefaults{
    private enum Keys{
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let isLoggedIn = "isLoggedIn"
    }
    
    var hasSeenOnboarding:  Bool{
        get{
            return bool(forKey: Keys.hasSeenOnboarding)
        }
        set{
            set(newValue, forKey: Keys.hasSeenOnboarding)
        }
    }
    
    var isLoggedIn: Bool {
        get{
            return bool(forKey: Keys.isLoggedIn)
        }
        set{
            set(newValue, forKey: Keys.isLoggedIn)
        }
    }
}
