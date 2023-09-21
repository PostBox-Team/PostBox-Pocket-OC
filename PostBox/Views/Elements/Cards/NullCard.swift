//
//  NullCard.swift
//  PostBox
//
//  Created by Polarizz on 5/24/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct NullCard: View {
    
    private var symbol: String
    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey
    private var custom: Bool
    
    init(symbol: String, title: LocalizedStringKey, desc: LocalizedStringKey, custom: Bool) {
        self.symbol = symbol
        self.title = title
        self.desc = desc
        self.custom = custom
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)

                Text(desc)
                    .font(.system(size: Types.subheadline))
                    .fontWeight(.regular)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
            
            SFSymbol(symbol, custom)
                .font(.system(size: Types.body+2))
                .foregroundColor(Color(.tertiaryLabel))
                .padding(.leading, 10)
                .padding(.trailing, 5)
        }
        .padding(16)
        .foregroundColor(.secondary)
        .background(Color(.quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct HomeNullCard: View {
    var body: some View {
        NullCard(
            symbol: "tray",
            title: "No Repos Added L",
            desc: "Add repos to see recently updated packages. L",
            custom: false
        )
        .padding(.horizontal, UIConstants.margin)
        .padding(.top, 6)
    }
}
