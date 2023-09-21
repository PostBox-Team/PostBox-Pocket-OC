//
//  WarningCard.swift
//  PostBox
//
//  Created by Polarizz on 1/31/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct WarningCard: View {
    
    private var link: String
    private var text: String
    private var symbol: String
    
    init(link: String, text: String, symbol: String) {
        self.link = link
        self.text = text
        self.symbol = symbol
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Tap to add and refresh ")
                    .font(.system(size: Types.subheadline))
                    .fontWeight(.regular)
                + Text(link)
                    .font(.system(size: Types.subheadline, design: .monospaced))
                    .foregroundColor(.red)
                + Text(text)
                    .font(.system(size: Types.subheadline))
                    .fontWeight(.regular)
            }
            .foregroundColor(.primary)

            Spacer()

            Image(systemName: symbol)
                .font(.system(size: Types.subheadline).weight(.medium))
                .foregroundColor(Color(.tertiaryLabel))
                .padding(.leading, 10)
                .padding(.trailing, 5)
        }
        .padding(16)
        .background(Color(.quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
