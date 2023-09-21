//
//  PageViews.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 8/3/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

// Don't know inheritence in Swift moment
struct DepictionStackView: View {
    
    var views: [DepictionObjectView]
    var landscape: Bool
    var color: String
    var stacked: Bool
    var inModal: Bool

    init(views: [DepictionObjectView], landscape: Bool, color: String, stacked: Bool, inModal: Bool) {
        self.views = views
        self.landscape = landscape
        self.color = color
        self.stacked = stacked
        self.inModal = inModal
    }
    
    /// Use the below initializers if it is the root view
    
    init(depiction: DepictionObjectView, inModal: Bool?=false) {
        self.views = depiction.views ?? [DepictionObjectView]()
        if Defaults.bool(forKey: "setting-colorful-depicts"), let tint = depiction.tintColor, tint.count > 0 {
            self.color = tint
        } else {
            self.color = "#8E8E93"
        }
        self.inModal = inModal!
        self.landscape = false
        self.stacked = false
    }
    
    init(depiction: SileoDepiction, inModal: Bool?=false) {
        self.views = depiction.views ?? [DepictionObjectView]()
        if Defaults.bool(forKey: "setting-setting-colorful-depicts"), let tint = depiction.tintColor, tint.count > 0 {
            self.color = tint
        } else {
            self.color = "#8E8E93"
        }
        self.inModal = inModal!
        self.landscape = false
        self.stacked = false
    }
    
    @ViewBuilder
    var foreach: some View {
        ForEach(views.indices, id: \.self) { i in
            switch views[i].class {
            case "DepictionMarkdownView":
                DepictionMarkdownView(data: views[i], color: color)
            case "DepictionHeaderView":
                DepictionHeaderView(data: views[i])
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionScreenshotsView":
                DepictionScreenshotsView(data: views[i])
            case "DepictionSubheaderView":
                DepictionSubheaderView(data: views[i])
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionSeparatorView":
                DepictionSeparatorView()
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionTableTextView":
                DepictionTableTextView(data: views[i])
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionSpacerView":
                DepictionSpacerView(data: views[i])
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionImageView":
                DepictionImageView(data: views[i])
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionRatingView":
                DepictionRatingView(data: views[i])
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionTableButtonView":
                DepictionTableButtonView(data: views[i], inModal: inModal)
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionStackView":
                DepictionStackView(
                    views: views[i].views!,
                    landscape: (views[i].orientation ?? "") == "landscape",
                    color: color,
                    stacked: true,
                    inModal: inModal
                )
                .padding(.horizontal, stacked ? 0 : UIConstants.margin)
                .background(views[i].backgroundColor == nil ? Color.clear : Color(hex: views[i].backgroundColor!))
            case "DepictionLabelView":
                DepictionLabelView(data: views[i])
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionAdmobView":
                Spacer().frame(height: 20)
            case "DepictionButtonView":
                DepictionButtonView(data: views[i], color: color, inModal: inModal)
                    .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "HiddenDepictionScreenshotsView":
                Spacer().frame(height: 0)
            case "DepictionLayerView":
                ZStack(alignment: .leading) {
                    AnyView(
                        DepictionStackView(
                            views: views[i].views!,
                            landscape: false,
                            color: color,
                            stacked: true,
                            inModal: inModal
                        )
                        .foreach
                    )
                }
                .padding(.horizontal, stacked ? 0 : UIConstants.margin)
            case "DepictionTabView":
                DepictionTabView(depiction: views[i], inModal: inModal)
            default:
                Text(views[i].class)
            }
        }
    }
    
    @ViewBuilder
    var body: some View {
        if landscape {
            HStack { foreach }
        } else {
            VStack(alignment: .leading) { foreach }
        }
    }
}
