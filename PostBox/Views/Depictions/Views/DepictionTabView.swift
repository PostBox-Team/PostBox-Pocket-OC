//
//  DepictionTabView.swift
//  PostBox
//
//  Created by b0kch01 on 11/14/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}

struct DepictionTabView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @State private var tab = 0
    
    var color: String
    var tabs: [DepictionObjectView]
    var inModal: Bool
    
    init(depiction: DepictionObjectView, inModal: Bool?=false) {
        self.tabs = depiction.tabs ?? [DepictionObjectView]()
        
        if Defaults.bool(forKey: "setting-colorful-depicts"), let tint = depiction.tintColor, tint.count > 0 {
            self.color = tint
        } else {
            self.color = "#8E8E93"
        }
        
        self.inModal = inModal!
    }
    
    init(depiction: SileoDepiction, inModal: Bool?=false) {
        self.tabs = depiction.tabs ?? [DepictionObjectView]()
        
        if Defaults.bool(forKey: "setting-colorful-depicts"), let tint = depiction.tintColor, tint.count > 0 {
            self.color = tint
        } else {
            self.color = "#8E8E93"
        }
        
        self.inModal = inModal!
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if tabs.count > 1 {
                Picker("Tab Select", selection: $tab, content: {
                    ForEach(tabs.indices, id: \.self) { i in
                        if let text = tabs[i].tabname?.replacingOccurrences(of: "Changelog", with: "Changes") {
                            Text(text)
                        }
                    }
                })
                .pickerStyle(SegmentedPickerStyle())
                .frame(height: 35)
                .padding(.horizontal, UIConstants.margin)
                .padding(.bottom, 10)
            }
            
            ZStack(alignment: .top) {
                ForEach(tabs.indices, id: \.self) { i in
                    if let views = tabs[i].views {
                        DepictionStackView(
                            views: views,
                            landscape: false,
                            color: color,
                            stacked: false,
                            inModal: inModal
                        )
                        .frame(maxHeight: tab == i ? .infinity : 0)
                        .opacity(tab == i ? 1 : 0)
                    } else {
                        DepictionStackView(
                            views: [tabs[i]],
                            landscape: false,
                            color: color,
                            stacked: false,
                            inModal: inModal
                        )
                        .frame(maxHeight: tab == i ? .infinity : 0)
                        .opacity(tab == i ? 1 : 0)
                    }
                }
            }
        }
    }
}
