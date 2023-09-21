//
//  SettingsAppIcon.swift
//  PostBox
//
//  Created by Polarizz on 8/25/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI
import Grid

struct SettingsAppIcon: View {
    
    @State private var chosenIcon = UIApplication.shared.alternateIconName ?? "IconWhite"
    
    let customIcons: [String] = [
        "IconColor",
        "IconColorDark",
        "IconSupport",
        "IconSupportDark"
    ]
    
    let coloredIcons: [String] = [
        "IconRed",
        "IconOrange",
        "IconYellow",
        "IconGreen",
        "IconMint",
        "IconCyan",
        "IconBlue",
        "IconPurple",
        "IconPink",
        "IconBrown"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SettingsSectionHeader("Default LU")
                
                HStack(alignment: .center, spacing: 16) {
                    AppIconOption("IconWhite", chosen: $chosenIcon)
                    AppIconOption("IconBlack", chosen: $chosenIcon)
                    AppIconOption("IconBlack", chosen: $chosenIcon).opacity(0)
                }
                .padding(.bottom, 20)
                
                SettingsSectionHeader("LOL LU")
                
                HStack(alignment: .center, spacing: 16) {
                    AppIconOption("MinxterIcon", "Made by m1nxy", chosen: $chosenIcon)
                    AppIconOption("IconBlack", chosen: $chosenIcon).opacity(0)
                    AppIconOption("IconBlack", chosen: $chosenIcon).opacity(0)
                }
                .padding(.bottom, 20)
                
                SettingsSectionHeader("Custom LU")
                
                Grid(customIcons, id: \.self) { icon in
                    AppIconOption(icon, chosen: $chosenIcon)
                }
                .gridStyle(StaggeredGridStyle(.vertical, tracks: 3, spacing: 16))
                .padding(.bottom, 20)

                SettingsSectionHeader("Colored LU")
                
                Grid(coloredIcons, id: \.self) { icon in
                    AppIconOption(icon, chosen: $chosenIcon)
                }
                .gridStyle(StaggeredGridStyle(.vertical, tracks: 3, spacing: 16))
                
                Spacer()
            }
            .padding(UIConstants.margin)
        }
        .navigationBarTitle("App Icon", displayMode: .inline)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
}

struct AppIconOption: View {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding private var chosen: String
    
    private let width: CGFloat = 55
    
    private var icon: String
    private var desc: String?
    
    init(_ icon: String, _ desc: String?=nil, chosen: Binding<String>) {
        self.icon = icon
        self.desc = desc
        self._chosen = chosen
    }
    
    var iconChosen: Bool { chosen == icon }
    
    var body: some View {
        Button(action: {
            Haptics.shared.play(.light)

            withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                chosen = icon
            }
            
            UIApplication.shared.setAlternateIconName("App" + icon)
        }) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    CenterStack {
                        Image(icon).resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width, height: width)
                            .clipShape(RoundedRectangle(cornerRadius: 0.2239 * width, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 0.2239 * width, style: .continuous)
                                    .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                    .opacity(0.3)
                            )
                    }
                    .frame(height: geo.size.width)
                    .background(iconChosen ? Color(.tertiarySystemBackground) : Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    .shadow(color: Color.black.opacity(iconChosen ? (colorScheme == .dark ? 0.09 : 0.03) : 0), radius: 15, y: 10)
                    
                    if let desc = desc {
                        Text(desc)
                            .font(.system(size: Types.caption))
                            .foregroundColor(Color(.tertiaryLabel))
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                    }
                    
                    Button(action: {
                        Haptics.shared.play(.light)
                        
                        withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                            chosen = icon
                        }
                        
                        UIApplication.shared.setAlternateIconName("App" + icon)
                    }) {
                        Image("checkmark.app.fill")
                            .font(.system(size: Types.title2))
                            .foregroundColor(iconChosen ? Color.accentColor : Color(.tertiaryLabel))
                            .scaleEffect(iconChosen ? 1 : 0.001)
                            .background(
                                Image("app")
                                    .font(.system(size: Types.title2))
                                    .foregroundColor(Color(.tertiaryLabel))
                                    .scaleEffect(iconChosen ? 0.8 : 1)
                            )
                            .contentShape(Rectangle())
                    }
                    .padding(.top, 11)
                }
            }
            .aspectRatio(contentMode: .fit)
        }
        .buttonStyle(CardButtonStyle())
        .padding(.bottom, 40)
    }
}
