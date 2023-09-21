//
//  RoundedSymbol.swift
//  Pocket
//
//  Created by Polarizz on 9/12/22.
//  Copyright © 2022 PostBox Team. All rights reserved.
//

import SwiftUI

struct RoundedSymbol: View {
    
    private var icon: String
    private var foreground: Color
    private var background: Color
    private var custom: Bool
    
    init(icon: String, foreground: Color, background: Color, custom: Bool) {
        self.icon = icon
        self.foreground = foreground
        self.background = background
        self.custom = custom
    }
    
    var body: some View {
        Group {
            SFSymbol(icon, custom)
                .font(.system(size: Types.body))
                .frame(
                    width: Types.body,
                    height: Types.body
                )
        }
        .foregroundColor(foreground)
        .padding(7)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
}

struct RoundedSymbolLarge: View {
    
    private var icon: String
    private var foreground: Color
    private var background: Color
    private var custom: Bool
    
    init(icon: String, foreground: Color, background: Color, custom: Bool) {
        self.icon = icon
        self.foreground = foreground
        self.background = background
        self.custom = custom
    }
    
    var body: some View {
        Group {
            SFSymbol(icon, custom)
                .font(.system(size: UIConstants.title3))
                .frame(
                    width: Types.title3,
                    height: Types.title3
                )
        }
        .foregroundColor(foreground)
        .padding(11)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
}
