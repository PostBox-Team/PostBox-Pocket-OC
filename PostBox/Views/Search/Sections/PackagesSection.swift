//
//  PackagesSection.swift
//  PostBox
//
//  Created by b0kch01 on 12/18/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct PackagesSection: View {
        
    var packages: [Package]

    init(packages: [Package]) {
        self.packages = packages
    }

    var body: some View {
        ForEach(packages.sorted()) { package in
            VStack(spacing: 0) {
                Button(action: {
                    sceneManager.destPackage = package
                    sceneManager.navigateType = .package
                }) {
                    HStack(alignment: .center, spacing: 0) {
                        package.iconView
                            .frame(width: 45, height: 45)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: Package.appCornerRadius(width: 45), style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: Package.appCornerRadius(width: 45), style: .continuous)
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
                                .lineLimit(2)
                        }

                        Spacer()

                    }
                    .foregroundColor(.primary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, UIConstants.margin/2)
                    .contentShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                }
                .buttonStyle(ListButtonStyle())
                .padding(.horizontal, UIConstants.margin/2)

                Bar()
                    .padding(.leading, 45 + 13 + UIConstants.margin)
            }
        }
    }
}
