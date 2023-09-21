//
//  HomeViewRecents.swift
//  PostBox
//
//  Created by Nathan Choi on 8/27/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct HomeViewRecents: View {
    
    @EnvironmentObject var packageManager: PackageManager
    
    @ObservedObject private var viewModel = HomeViewModel.shared
    
    let preferredLanguage = NSLocale.preferredLanguages[0]

    @State private var recentPrefix = 20
    
    var body: some View {
        VerticalStack(alignment: .center, spacing: 0) {
            ForEach(packageManager.versionHistory.filter { time in
                time.versions.filter { PackageManager.packages[$0.id] != nil }.count > 0
            }) { history in
                HStack(spacing: 0) {
                    Group {
                        if viewModel.timeStyle == 0 {
                            SectionHeaderNoLocalization(history.date.getElapsedInterval(true))
                                .onTapGesture { viewModel.setTimeStyle(1) }
                        } else if viewModel.timeStyle == 1 {
                            SectionHeaderNoLocalization(history.date.generalPrecision())
                                .onTapGesture { viewModel.setTimeStyle(0) }
                        }
                    }
                    
                    Spacer()
                        
                    Group {
                        Image(systemName: "arrow.up.doc.on.clipboard")
                            .font(.system(size: Types.callout))
                        
                        Image(systemName: "plus")
                            .font(.system(size: Types.body))
                    }
                    .opacity(0)
                }
                .padding(.horizontal, UIConstants.margin)
                .padding(.top, 21)
                .padding(.bottom, 13)

                ForEach(history.versions.prefix(recentPrefix)) { version in
                    if let package = PackageManager.packages[version.id] {
                        NavigationLink(destination: PackageView(package)) {
                            PackageCard(package: package, type: .change, version: version)
                        }
                        .buttonStyle(NoButtonStyle())
                        
                        Bar()
                            .padding(.leading, 61)
                            .padding(.horizontal, UIConstants.margin)
                    }
                }
                
                if history.versions.filter({ PackageManager.packages[$0.id] != nil }).count > recentPrefix {
                    Button(action: {
                        withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                            recentPrefix += 20
                        }
                    }) {
                        if preferredLanguage == "zh-Hans"{
                            CaptionCard(
                                title: "正在显示\(history.versions.count)个软件包中的前\(recentPrefix)个",
                                desc: "点击加载更多"
                            )
                        } else if preferredLanguage == "zh-Hant"{
                            CaptionCard(
                                title: "正在显示\(history.versions.count)个软件包中的前\(recentPrefix)个",
                                desc: "點擊加載更多"
                            )
                        } else {
                            CaptionCard(
                                title: "Showing the first \(recentPrefix) of \(history.versions.count) packages.",
                                desc: "Tap here to load more"
                            )
                        }
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .padding([.horizontal, .top], UIConstants.margin)
                }
            }
        }
    }
}
