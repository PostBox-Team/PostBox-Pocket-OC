//
//  CaptionCard.swift
//  PostBox
//
//  Created by Polarizz on 8/6/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct CaptionCard: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    private var title: String
    private var desc: String
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: Types.callout).weight(.medium))
                
                Text(desc)
                    .font(.system(size: Types.subheadline).weight(.regular))
            }
            .foregroundColor(.secondary)

            Spacer()

            Image(systemName: "plus")
                .font(.system(size: Types.subheadline).weight(.medium))
                .foregroundColor(Color(.tertiaryLabel))
                .padding(.leading, 10)
                .padding(.trailing, 3)
        }
        .padding(16)
        .background(Color(.quaternarySystemFill).opacity(colorScheme == .dark ? 0.5 : 1))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
