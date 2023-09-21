//
//  RepoIconViews.swift
//  PostBox
//
//  Created by b0kch01 on 7/24/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI
import URLImage

extension Repo {
    
    static func appCornerRadius(width: CGFloat) -> CGFloat { CGFloat((0.2239) * Double(width)) }
    
    // MARK: - Repository Icon Views
    @ViewBuilder var iconView: some View {
        if URLFunction.valid(iconURL), let url = URL(string: iconURL) {
            URLImage(
                url: url,
                empty: { [weak self] in self?.emptyImage },
                inProgress: { [weak self] _ in self?.loadingImage },
                failure: { [weak self] _, _ in self?.failedImage },
                content: { img in
                    img
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            )
        } else {
            emptyImage
        }
    }
    
    private var emptyImage: some View {
        Text(name.prefix(1).uppercased())
            .font(.system(size: Types.title, design: .rounded))
            .foregroundColor(Color(.tertiaryLabel))
    }
    
    private var loadingImage: some View {
        Text("")
    }
    
    private var failedImage: some View {
        Image(systemName: "wifi.exclamationmark")
            .font(.title)
            .foregroundColor(Color(.tertiaryLabel))
    }
    
    @ViewBuilder var iconViewCard: some View {
        if Defaults.bool(forKey: "setting-enable-icon-rendering"), URLFunction.valid(iconURL) {
            URLImage(
                url: URLFunction.url(iconURL),
                empty: { [weak self] in self?.emptyImage },
                inProgress: { [weak self] _ in self?.loadingImage },
                failure: { [weak self] _, _ in self?.failedImage },
                content: { img in
                    img.renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            )
        } else {
            emptyImage
        }
    }
    
    @ViewBuilder var iconViewLoading: some View {
        if URLFunction.valid(iconURL) {
            URLImage(
                url: URLFunction.url(iconURL),
                empty: {
                    ActivityIndicator()
                },
                inProgress: { _ in
                    ActivityIndicator()
                },
                failure: { _, _ in
                    ActivityIndicator()
                },
                content: { img in
                    img.renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            )
        } else {
            ActivityIndicator()
                .transition(.scale)
        }
    }
}
