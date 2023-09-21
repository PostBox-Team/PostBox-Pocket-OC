//
//  DownloadList.swift
//  PostBox
//
//  Created by b0kch01 on 7/27/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct DownloadList: View {
    
    @EnvironmentObject var packageManager: PackageManager
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(packageManager.workingPackages.suffix(4)) { package in
                HStack(alignment: .center, spacing: 0) {
                    package.iconView
                        .frame(width: 45, height: 45)
                        .clipShape(RoundedRectangle(cornerRadius: 45 * 0.2239, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 45 * 0.2239, style: .continuous)
                                .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                .opacity(0.3)
                        )
                        .padding(.trailing, 16)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(package.name)
                            .font(.system(size: Types.callout))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Text(package.description)
                            .font(.system(size: Types.subheadline))
                            .fontWeight(.regular)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    PackageProgressView(package: package)
                        .padding(.trailing, 5)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, UIConstants.margin)
                .background(Color.primaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                
                Bar()
                    .padding(.leading, 61)
                    .padding(.horizontal, UIConstants.margin)
            }
            .animation(.spring(response: 0.2, dampingFraction: 1), value: packageManager.workingPackages)
        }
    }
}
