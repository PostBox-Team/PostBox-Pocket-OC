//
//  SileoDepiction.swift
//  PostBox
//
//  Created by b0kch01 on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

/// `DepictionTabView` in Sileo docs
struct SileoDepiction: Codable {
    
    // Required field
    var `class`: String?
    var minVersion: FlexibleString?
    var tabs: [DepictionObjectView]?
    var views: [DepictionObjectView]?
    
    // Optional fields
    var headerImage: String?
    var tintColor: String?
    var backgroundColor: String?
}
