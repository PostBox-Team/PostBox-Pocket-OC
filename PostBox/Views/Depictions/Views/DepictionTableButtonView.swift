//
//  DepictionTableButtonView.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 7/28/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import BetterSafariView

struct DepictionTableButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var show = false
    @State var showStack = false
    @State var showError = false
    
    var data: DepictionObjectView
    var inModal: Bool
    
    init(data: DepictionObjectView, inModal: Bool?=false) {
        self.data = data
        self.inModal = inModal!
    }
    
    var body: some View {
        Button(action: {
            guard let str = data.action else {
                return showError.toggle()
            }
            
            if str.hasPrefix("depiction-") {
                return showStack.toggle()
            } else if let url = URL(string: str) {
                if inModal || str.hasPrefix("mailto:") && UIApplication.shared.canOpenURL(url) {
                    return UIApplication.shared.open(url)
                } else if URLFunction.valid(str) {
                    return show.toggle()
                }
            }
            
            guard let strB = data.backAction else {
                return showError.toggle()
            }
            
            if let url = URL(string: str) {
                if inModal || strB.hasPrefix("mailto:") && UIApplication.shared.canOpenURL(url) {
                    return UIApplication.shared.open(url)
                } else if URLFunction.valid(strB) {
                    return show.toggle()
                }
            }
            
            showError.toggle()
        }) {
            HStack {
                Text(data.title ?? "")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(Font.callout.weight(.medium))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(.vertical, 10)
        }
        .safariView(isPresented: $show) {
            if #available(iOS 14.0, *) {
                return SafariView(
                    url: URLFunction.cleanURL(data.action),
                    configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                    )
                )
                .preferredControlAccentColor(.primary)
                .dismissButtonStyle(.done)
            } else {
                return SafariView(
                    url: URLFunction.cleanURL(data.action),
                    configuration: SafariView.Configuration(
                        entersReaderIfAvailable: false,
                        barCollapsingEnabled: true
                    )
                )
                .dismissButtonStyle(.done)
            }
        }
        .sheet(isPresented: $showStack) {
            if let str = data.action, let url = URL(string: String(str.dropFirst(10))) {
                MiniDepictionView(with: url, color: data.tintColor ?? Color.accentColor.hex)
            }
        }
        .background(
            EmptyView()
                .sheet(isPresented: $showError) {
                    VStack {
                        ScrollView {
                            VStack {
                                SplashHeader(
                                    "Feature Unavailable"
//                                    "We are currently working on bring this feature to future versions of PostBox."
                                )
                            }
                            .padding(.horizontal, UIConstants.margin)
                        }
                        
                        Spacer()

                    }
                }
        )
    }
}
