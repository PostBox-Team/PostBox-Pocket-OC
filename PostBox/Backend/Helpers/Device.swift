//
//  DeviceInfo.swift
//  PostBox
//
//  Created by b0kch01 on 11/10/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation
import UIKit

struct Device {
    /// iOS Version
    static let version = UIDevice.current.systemVersion
    /// `VendorID` with `UDID` format
    static let udid: String = (UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString)
        .replacingOccurrences(of: "-", with: "42")
    
    /// Get device model
    static func model() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let modelCode = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return modelCode
    }
}
