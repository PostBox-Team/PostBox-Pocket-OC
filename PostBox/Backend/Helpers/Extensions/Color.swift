//
//  Color.swift
//  PostBox
//
//  Created by b0kch01 on 11/9/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

/// Color constants
extension Color {
    static let accentColor            = Color("accentColor")
    static let primaryBackground      = Color("primaryBackground")
    static let secondaryBackground    = Color("secondaryBackground")
    static let quaternaryBackground   = Color("quaternaryBackground")
    static let partialSheetBackground = Color("partialSheetBackground")
    static let quaternarySolid        = Color("quaternarySolid")
}

/// https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}

/// Converts `Color` to `UIColor`:
/// https://stackoverflow.com/questions/57257704/how-can-i-change-a-swiftui-color-to-uicolor?rq=1
extension Color {
    var hex: String {
        let colors = components()
        return "rgb(\(colors.red * 255), \(colors.blue * 255), \(colors.green * 255))"
    }

    func uiColor() -> UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let components = self.components()

        return UIColor(
            red: components.red/255,
            green: components.green/255,
            blue: components.blue/255,
            alpha: components.alpha/255
        )
    }

    func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            alpha = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (red, green, blue, alpha)
    }
}

/// Create a new UIColor instance from hex string
func hexStringToUIColor(hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }

    if cString.count != 6 {
        return UIColor.gray
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
