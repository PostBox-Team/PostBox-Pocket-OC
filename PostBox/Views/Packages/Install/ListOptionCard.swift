//
//  ListOptionCard.swift
//  PostBox
//
//  Created by Polarizz on 4/19/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ListOptionCard: View {

    @Environment(\.colorScheme) var colorScheme
    
    @State private var iconWidth: CGFloat = 40
        
    private var image: String?
    private var name: String
    private var desc: String
    private var symbol: String

    init(image: String?=nil, name: String, desc: String, symbol: String) {
        self.image = image
        self.name = name
        self.desc = desc
        self.symbol = symbol
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if let image = image {
                Image(image).resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: iconWidth, height: iconWidth)
                    .background(Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous)
                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                            .opacity(0.3)
                    )
                    .padding(.trailing, 11)
            }
                        
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(desc)
                    .font(.system(size: Types.subheadline))
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()

            InstallButton(
                symbol,
                Color(.tertiaryLabel)
            )
            .padding(.trailing, 5)
        }
        .padding(16)
        .background(Color(.quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct ListOptionCardSolid: View {

    @Environment(\.colorScheme) var colorScheme
    
    @State private var iconWidth: CGFloat = 40
        
    private var image: String?
    private var name: LocalizedStringKey
    private var desc: LocalizedStringKey
    private var symbol: String

    init(image: String?=nil, name: LocalizedStringKey, desc: LocalizedStringKey, symbol: String) {
        self.image = image
        self.name = name
        self.desc = desc
        self.symbol = symbol
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if let image = image {
                Image(image).resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: iconWidth, height: iconWidth)
                    .background(Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous)
                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                            .opacity(0.3)
                    )
                    .padding(.trailing, 11)
            }
                        
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(desc)
                    .font(.system(size: Types.subheadline))
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()

            InstallButton(
                symbol,
                Color(.tertiaryLabel)
            )
            .padding(.trailing, 5)
        }
        .padding(16)
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.09 : 0.03), radius: 20, y: 10)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct ListOptionCardSolidNoLocalization: View {

    @Environment(\.colorScheme) var colorScheme
    
    @State private var iconWidth: CGFloat = 40
        
    private var image: String?
    private var name: String
    private var desc: LocalizedStringKey
    private var symbol: String

    init(image: String?=nil, name: String, desc: LocalizedStringKey, symbol: String) {
        self.image = image
        self.name = name
        self.desc = desc
        self.symbol = symbol
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if let image = image {
                Image(image).resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: iconWidth, height: iconWidth)
                    .background(Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous)
                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                            .opacity(0.3)
                    )
                    .padding(.trailing, 11)
            }
                        
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(desc)
                    .font(.system(size: Types.subheadline))
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)

            Spacer()

            InstallButton(
                symbol,
                Color(.tertiaryLabel)
            )
            .padding(.trailing, 5)
        }
        .padding(16)
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.09 : 0.03), radius: 20, y: 10)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct ListOptionCardToggle: View {

    @Environment(\.colorScheme) var colorScheme
    
    @State private var iconWidth: CGFloat = 40
        
    private var image: String?
    private var name: LocalizedStringKey
    private var desc: LocalizedStringKey?
    private var symbol: String
    private var foreground: Color
    private var background: Color
    private var shadow: Bool
    private var disabled: Bool

    init(image: String?=nil, name: LocalizedStringKey, desc: LocalizedStringKey?=nil, symbol: String, foreground: Color, background: Color, shadow: Bool, disabled: Bool) {
        self.image = image
        self.name = name
        self.desc = desc
        self.symbol = symbol
        self.foreground = foreground
        self.background = background
        self.shadow = shadow
        self.disabled = disabled
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if let image = image {
                Image(image).resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: iconWidth, height: iconWidth)
                    .background(Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous)
                            .fill(Color(.systemBackground).opacity(disabled ? 0.5 : 0))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous)
                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                            .opacity(0.3)
                    )
                    .padding(.trailing, 11)
            }
                        
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                if let desc = desc {
                    Text(desc)
                        .font(.system(size: Types.subheadline))
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                        .padding(.top, 3)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .opacity(disabled ? 0.5 : 1)
            
            Spacer()

            InstallButton(
                symbol,
                foreground
            )
            .padding(.trailing, 5)
        }
        .padding(16)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .shadow(color: Color.black.opacity(shadow ? (colorScheme == .dark ? 0.09 : 0.03) : 0), radius: 15, y: 10)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

struct ListOptionCardToggleNoLocalization: View {

    @Environment(\.colorScheme) var colorScheme
    
    @State private var iconWidth: CGFloat = 40
        
    private var image: String?
    private var name: String
    private var desc: LocalizedStringKey?
    private var symbol: String
    private var foreground: Color
    private var background: Color
    private var shadow: Bool
    private var disabled: Bool

    init(image: String?=nil, name: String, desc: LocalizedStringKey?=nil, symbol: String, foreground: Color, background: Color, shadow: Bool, disabled: Bool) {
        self.image = image
        self.name = name
        self.desc = desc
        self.symbol = symbol
        self.foreground = foreground
        self.background = background
        self.shadow = shadow
        self.disabled = disabled
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if let image = image {
                Image(image).resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: iconWidth, height: iconWidth)
                    .background(Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous)
                            .fill(Color(.systemBackground).opacity(disabled ? 0.5 : 0))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 0.2239 * iconWidth, style: .continuous)
                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                            .opacity(0.3)
                    )
                    .padding(.trailing, 11)
            }
                        
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                if let desc = desc {
                    Text(desc)
                        .font(.system(size: Types.subheadline))
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                        .padding(.top, 3)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .opacity(disabled ? 0.5 : 1)
            
            Spacer()

            InstallButton(
                symbol,
                foreground
            )
            .padding(.trailing, 5)
        }
        .padding(16)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .shadow(color: Color.black.opacity(shadow ? (colorScheme == .dark ? 0.09 : 0.03) : 0), radius: 15, y: 10)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
