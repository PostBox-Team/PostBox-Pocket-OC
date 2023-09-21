//
//  FeaturedPackageBanner.swift
//  PostBox
//
//  Created by b0kch01 on 1/31/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import URLImage

struct FeaturedPackageBanner: View {

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var repo: Repo
    
    var banner: FeaturedBanner
    var url: URL

    var maxWidth: CGFloat {
        UIScreen.main.bounds.maxX - 48
    }
    
    var packageID: String {
        Package.genID(id: banner.package, url: repo.url)
    }

    var body: some View {
        NavigationLink(destination: PackageView(PackageManager.packages[packageID] ?? Package())) {
            bannerCard
        }
        .disabled(PackageManager.packages[packageID] == nil)
        .buttonStyle(CardButtonStyle())
    }
    
    private var bannerCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            URLImage(
                url: url, empty: { Color(.quaternarySystemFill) },
                inProgress: { _ in Color(.quaternarySystemFill) },
                failure: { _, _ in Color(.quaternarySystemFill) },
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            )
            .frame(width: maxWidth, height: maxWidth*(9/16))

            HStack(spacing: 0) {
                Text(banner.title)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding(16)
        }
        .frame(width: maxWidth)
        .background(colorScheme == .dark ? Color(.quaternarySystemFill) : Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.1), radius: 20, y: 5)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
