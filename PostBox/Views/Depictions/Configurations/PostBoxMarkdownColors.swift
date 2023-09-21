//
//  PostBoxMarkdownColors.swift
//  PostBox
//
//  Created by b0kch01 on 11/18/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation
import Down

/// Default Font Settings
struct DepictionFonts: FontCollection {
    
    /// Headings
    var heading1 = DownFont.boldSystemFont(ofSize: 28)
    var heading2 = DownFont.boldSystemFont(ofSize: 24)
    var heading3 = DownFont.boldSystemFont(ofSize: 18)
    var heading4 = DownFont.boldSystemFont(ofSize: 16)
    var heading5 = DownFont.boldSystemFont(ofSize: 14)
    var heading6 = DownFont.boldSystemFont(ofSize: 12)
    
    var body = DownFont.systemFont(ofSize: 16)
    
    /// Code stuff
    var code = DownFont(name: "menlo", size: 16) ?? .systemFont(ofSize: 16)
    var listItemPrefix = DownFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
}
