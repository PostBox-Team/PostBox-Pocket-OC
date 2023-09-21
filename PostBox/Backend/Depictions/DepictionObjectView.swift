//
//  DepictionObjectView.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 7/22/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation
import SwiftUI

class DepictionObjectView: Codable, Identifiable {
    
    /// Converts the margin string into a list of values
    func getMargins() -> [CGFloat] {
        guard var margins = margins else {
            return [.zero, .zero, .zero, .zero]
        }
        
        margins = margins.replacingOccurrences(of: " ", with: "")
        margins = String(margins.dropFirst(1).dropLast(1))
        
        return margins.components(separatedBy: ",").map {
            CGFloat(Double($0) ?? 0)
        }
    }
    /// Converts the size string into a list of values
    func getSize() -> [CGFloat] {
        guard var size = itemSize?.value, size != "false" else {
            return [.zero, .zero, .zero, .zero]
        }
        
        size = size.replacingOccurrences(of: " ", with: "")
        size = String(size.dropFirst(1).dropLast(1))
        return size.components(separatedBy: ",").map {
            CGFloat(Double($0) ?? 0)
        }
    }
    
    var `class`: String
    
    /// StackView
    var views: [DepictionObjectView]?
    var orientation: String?
    var margins: String?
    
    /// Header | SubHeader
    var title: String?
    var useMargins: FlexibleString?
    var useBottomMargin: FlexibleString?
    var useBoldText: FlexibleString?
    var alignment: Int?
    
    /// Labels
    var text: String?
    var usePadding: FlexibleString?
    var fontWeight: String?
    var fontSize: FlexibleString?
    var textColor: String?
    
    /// Markdown
    var markdown: String?
    var useSpacing: FlexibleString?
    var useRawFormat: FlexibleString?
    var tintColor: String?
    var backgroundColor: String?
    
    /// Videos
    var URL: String?
    var width: Double?
    var height: Double?
    var cornerRadius: Double?
    var autoplay: Bool?
    var showPlaybackControls: FlexibleString?
    var loop: Bool?
    
    /// Images
    var horizontalPadding: Double?

    /// Screenshots
    var screenshots: [Screenshot]?
    var itemCornerRadius: Double?
    var itemSize: FlexibleString?
    var iPhone: DepictionObjectView?
    var iPad: DepictionObjectView?
    
    /// Table Text  | `title`, `text`
    /// Table Button & Button
    var action: String?
    var backAction: String?
    var openExternal: FlexibleString?
    var yPadding: Double?
    var view: DepictionObjectView?
    
    /// Spacer
    var spacing: FlexibleString?
    
    /// Adverts (must research about Google AD API)
    
    /// Ratings
    var rating: Double?
    
    /// Reviews
    var author: String?
    
    /// Featured Banners
    var banners: [FeaturedBanner]?
    var url: String?
    var package: String?
    var hideShadow: FlexibleString?
    
    /// TabView
    var tabs: [DepictionObjectView]?
    var tabname: String?
    
    init(_ class: String?=nil, markdown: String?=nil, title: String?=nil, action: String?=nil) {
        self.class = `class` ?? ""
        self.markdown = markdown
        self.title = title
        self.action = action
    }
}

/// Screenshot Sileo depiction
struct Screenshot: Codable {
    var url: String
    var fullSizeURL: String?
    var accessibilityText: String
    var video: Bool?
}

/// Featured Banner
struct FeaturedBanner: Codable, Equatable {
    
    static func == (lhs: FeaturedBanner, rhs: FeaturedBanner) -> Bool {
        return lhs.url == lhs.url
    }
    
    var url: String
    var title: String
    var package: String
    var hideShadow: FlexibleString?
}
