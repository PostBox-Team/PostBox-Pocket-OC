//
//  Settings.swift
//  PostBox
//
//  Created by b0kch01 on 12/25/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsManager {
    
    /// Restore all settings
    static func restoreAll() {
        Defaults.dictionaryRepresentation().forEach { key, _ in
            if key.hasPrefix("setting-") {
                Defaults.removeObject(forKey: key)
            }
        }
        
        restoreSettings()
    }
    
    /// Restore all settings settings
    static func restoreSettings() {
        for item in [
            "setting-colorful-depicts",         // Changes tint color when entering PackageView
            "setting-auto-refresh",             // Automatically refreshes sources on launch
            "setting-enable-icon-rendering"     // Actual icons are fetched instead of a plain square
        ] {
            Defaults.set(true, forKey: item)
        }
        Defaults.synchronize()
    }
}
