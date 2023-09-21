//
//  RedactedPackageCard.swift
//  PostBox
//
//  Created by Polarizz on 1/2/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct RedactedListCard: View {
    
    private var symbol: String
    
    init(_ symbol: String) {
        self.symbol = symbol
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            RoundedRectangle(cornerRadius: 45 * 0.2239, style: .continuous)
                .fill(Color(.quaternarySystemFill))
                .frame(width: 45, height: 45)
                .overlay(
                    RoundedRectangle(cornerRadius: 45 * 0.2239, style: .continuous)
                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                        .opacity(0.3)
                )
                .padding(.trailing, 16)
                        
            VStack(alignment: .leading, spacing: 5) {
                Text("Redacted name")
                    .font(.system(size: Types.callout))
                    .lineLimit(1)
                    .foregroundColor(.primary.opacity(0))
                    .background(Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

                Text("Redacted content description")
                    .font(.system(size: Types.subheadline))
                    .lineLimit(1)
                    .foregroundColor(.primary.opacity(0))
                    .background(Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()

            if symbol != "" {
                InstallButton(
                    symbol,
                    Color(.tertiaryLabel)
                )
                .padding(.trailing, 5)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, UIConstants.margin)
        .background(Color.primaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
