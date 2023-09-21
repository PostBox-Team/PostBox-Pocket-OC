//
//  SettingsOption.swift
//  Pocket
//
//  Created by Polarizz on 9/12/22.
//  Copyright © 2022 PostBox Team. All rights reserved.
//

import SwiftUI

struct SettingsOption<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme

    @State private var navigate = false
    @State private var holding = false
    
    private var symbol: String
    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey
    private var custom: Bool
    
    private var content: Content
    
    init(symbol: String, title: LocalizedStringKey, desc: LocalizedStringKey, custom: Bool, @ViewBuilder content: () -> Content) {
        self.symbol = symbol
        self.title = title
        self.desc = desc
        self.custom = custom
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 13) {
            RoundedSymbolLarge(
                icon: symbol,
                foreground: .primary,
                background: Color(.quaternarySystemFill),
                custom: custom
            )
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(desc)
                    .font(.system(size: Types.subheadline).weight(.regular))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: UIConstants.callout).weight(.medium))
                .foregroundColor(Color(.tertiaryLabel))
                .padding(.trailing, 3)
        }
        .contentShape(Rectangle())
        .opacity(holding ? 0.5: 1)
        .onTapGesture { navigate.toggle() }
        .onLongPressGesture(
            minimumDuration: 99999,
            pressing: { state in
                holding = state
            },
            perform: {}
        )
        .background(NavigationLink("", destination: content, isActive: $navigate).disabled(true).frame(width: 0, height: 0))
    }
}
