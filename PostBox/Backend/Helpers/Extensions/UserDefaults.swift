//
//  UserDefaults.swift
//  PostBox
//
//  Created by b0kch01 on 8/1/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

extension UserDefaults {
    func color(forKey key: String) -> Color {
        var color = Color.primary
        if let colorData = data(forKey: key) {
            let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
            color = Color(uiColor ?? .systemBackground)
        }
        return color
    }

    func setColor(color: Color, forkey key: String) {
        guard let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color.uiColor(), requiringSecureCoding: false) else { return }
        set(colorData, forKey: key)
    }
}

// swiftlint:disable identifier_name
let Defaults = UserDefaults.standard
