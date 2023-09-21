//
//  BrowseRepoSection.swift
//  PostBox
//
//  Created by b0kch01 on 1/31/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct BrowseRepoSection: View {

    private var name: String
    private var count: Int
    private var icon: Bool
    
    init(name: String, count: Int, icon: Bool) {
        self.name = name
        self.count = count
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: 0) {
            if icon {
                Image(systemName: "archivebox.fill")
                    .font(.system(size: Types.body))
                    .foregroundColor(.primary)
                    .padding(.trailing, 7)
            }

            Text(name)
                .font(.system(size: Types.body))
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Spacer()

            Text(String(count))
                .font(.system(size: Types.callout))
                .foregroundColor(.secondary)
                .padding(.trailing, 10)

            Image(systemName: "chevron.right")
                .font(.system(size: UIConstants.callout).weight(.medium))
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.vertical, UIConstants.margin*0.9)
        .padding(.horizontal, UIConstants.margin*1.1)
    }
}
