//
//  IconCard.swift
//  Pocket
//
//  Created by Polarizz on 9/11/22.
//  Copyright © 2022 PostBox Team. All rights reserved.
//

import SwiftUI

struct IconCard: View {
    
    @Environment(\.colorScheme) var colorScheme

    private var icon: String
    private var title: LocalizedStringKey
    private var custom: Bool
    
    init(icon: String, title: LocalizedStringKey, custom: Bool) {
        self.icon = icon
        self.title = title
        self.custom = custom
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 13) {
            RoundedSymbol(
                icon: icon,
                foreground: Color(.systemBackground),
                background: Color.accentColor,
                custom: custom
            )
            
            Text(title)
                .font(.system(size: Types.body).weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(16)
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.09 : 0.03), radius: 20, y: 10)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
