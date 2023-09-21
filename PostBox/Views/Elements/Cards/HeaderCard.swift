//
//  HeaderCard.swift
//  PostBox
//
//  Created by Polarizz on 12/25/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct HeaderCard: View {
    
    @Environment(\.colorScheme) var colorScheme

    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey?
    private var symbol: String?
    
    init(title: LocalizedStringKey, desc: LocalizedStringKey?=nil, symbol: String?=nil) {
        self.title = title
        self.desc = desc
        self.symbol = symbol
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)

                if let desc = desc {
                    Text(desc)
                        .font(.system(size: Types.subheadline))
                        .fontWeight(.regular)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .foregroundColor(.primary)
            
            Spacer()
            
            if let symbol = symbol {
                Image(systemName: symbol)
                    .font(.system(size: Types.subheadline).weight(.medium))
                    .foregroundColor(Color(.tertiaryLabel))
                    .padding(.trailing, 5)
            }
        }
        .padding(16)
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.09 : 0.03), radius: 20, y: 10)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
