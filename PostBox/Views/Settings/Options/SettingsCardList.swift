//
//  SettingsCardList.swift
//  PostBox
//
//  Created by Polarizz on 11/10/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsCardList<Content: View>: View {
    
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
        HStack(alignment: .center, spacing: 0) {
            SFSymbol(symbol, custom)
                .font(.system(size: Types.body).weight(.regular))
                .frame(width: UIFont.preferredFont(forTextStyle: .body).pointSize)
                .padding(.trailing, 16)
            
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
        .padding(.vertical, 16)
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

struct SettingsCardListLink: View {
    
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
    }
}
