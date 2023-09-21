//
//  PackageIconViews.swift
//  PostBox
//
//  Created by b0kch01 on 7/24/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI
import URLImage

extension Package {
    
    /// Calculates the proper corner radius size based on icon size
    static func appCornerRadius(width: CGFloat) -> CGFloat { CGFloat((0.2239) * Double(width)) }
    
    // MARK: - Icon Image Views
    @ViewBuilder
    private var emptyImage: some View {
        GeometryReader { geo in
            CenterStack{
                Text(self.name.prefix(1).uppercased())
                    .font(.system(size: geo.size.width/1.9, design: .rounded))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .frame(height: geo.size.height)
            .background(Color(.quaternarySystemFill))
        }
    }
    
    @ViewBuilder
    private var loadingImage: some View {
        VStack {
            Spacer()
            HStack { Spacer() }
        }
        .background(Color(.quaternarySystemFill))
    }
    
    @ViewBuilder
    private var failedImage: some View {
        GeometryReader { geo in
            CenterStack{
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: geo.size.width/1.9))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .frame(height: geo.size.height)
            .background(Color(.quaternarySystemFill))
        }
    }
    
    /// Creates a resizable icon view of the package (defaults to empty if no connection)
    @ViewBuilder
    var iconView: some View {
        if Defaults.bool(forKey: "setting-enable-icon-rendering"), URLFunction.valid(icon), let url = URL(string: icon) {
            URLImage(
                url: url,
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
}
