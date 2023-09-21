//
//  LongButton.swift
//  PostBox
//
//  Created by Polarizz on 11/9/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct LongButton: View {
    
    private var text: LocalizedStringKey
    private var foreground: Color
    private var background: Color
    private var compact: Bool
    
    init(
        text: LocalizedStringKey,
        foreground: Color? = .white,
        background: Color? = .primary,
        compact: Bool?=false
    ) {
        self.text = text
        self.foreground = foreground!
        self.background = background!
        self.compact = compact!
    }
    
    var body: some View {
        CenterHStack {
            Text(text)
                .font(.system(size: Types.body))
                .fontWeight(.medium)
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundColor(foreground)
        .padding(.vertical, compact ? 10 : 16)
        .padding(.horizontal, 3)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct LongButtonNoLocalization: View {
    
    private var text: String
    private var foreground: Color
    private var background: Color
    private var compact: Bool
    
    init(
        text: String,
        foreground: Color? = .white,
        background: Color? = .primary,
        compact: Bool?=false
    ) {
        self.text = text
        self.foreground = foreground!
        self.background = background!
        self.compact = compact!
    }
    
    var body: some View {
        CenterHStack {
            Text(text)
                .font(.system(size: Types.body))
                .fontWeight(.medium)
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundColor(foreground)
        .padding(.vertical, compact ? 10 : 16)
        .padding(.horizontal, 3)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct LongButtonSymbol: View {
    
    private var symbol: String
    private var foreground: Color
    private var background: Color
    private var custom: Bool
    
    init(
        symbol: String,
        foreground: Color,
        background: Color,
        custom: Bool
    ) {
        self.symbol = symbol
        self.foreground = foreground
        self.background = background
        self.custom = custom
    }
    
    var body: some View {
        CenterHStack {
            SFSymbol(symbol, custom)
                .font(.system(size: Types.body).weight(.medium))
                .frame(height: Types.title3)
        }
        .foregroundColor(foreground)
        .padding(16)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct CenteredLongButton: View {
    
    private var text: LocalizedStringKey
    private var foreground: Color
    private var background: Color
    
    init(
        text: LocalizedStringKey,
        foreground: Color? = .white,
        background: Color? = .primary
    ) {
        self.text = text
        self.foreground = foreground!
        self.background = background!
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: Types.body))
            .fontWeight(.medium)
            .lineLimit(1)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(foreground)
            .padding(.vertical, 16)
            .padding(.horizontal, 40)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
