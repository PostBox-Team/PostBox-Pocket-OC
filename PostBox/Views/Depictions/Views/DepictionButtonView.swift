//
//  DepictionButtonView.swift
//  PostBox
//
//  Created by b0kch01 on 12/12/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct DepictionButtonView: View {
    
    var data: DepictionObjectView
    var color: String
    var inModal: Bool

    var backgroundColor: Color { data.tintColor != nil ? Color(hex: data.tintColor!) : .accentColor }

    // Removes margin if in a button
    var unsafeView: DepictionObjectView? {
        if let innerView = data.view {
            innerView.margins = nil
            innerView.textColor = color
            return innerView
        }

        return nil
    }

    var body: some View {
        Button(action: {
            if let url = URL(string: data.action ?? ""), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else if let url = URL(string: data.backAction ?? ""), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }) {
            if let view = unsafeView {
                DepictionStackView(
                    views: [view],
                    landscape: false,
                    color: color,
                    stacked: true,
                    inModal: inModal
                )
            } else {
                LongButtonNoLocalization(
                    text: data.text ?? "",
                    foreground: .white,
                    background: backgroundColor,
                    compact: true
                )
            }
        }
        .buttonStyle(DefaultButtonStyle())
    }
}
