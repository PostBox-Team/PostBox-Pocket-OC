//
//  HomePlatter.swift
//  PostBox
//
//  Created by Polarizz on 6/24/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct HomePlatter: View {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var showPackageHome: Bool
    @Binding var showRepoHome: Bool
        
    var body: some View {
        HStack(spacing: 13) {
            Button(action: {
                Haptics.shared.play(.light)

                withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                    showPackageHome = true
                    showRepoHome = false
                }
            }) {
                LeadingHStack {
                    VStack(alignment: .leading, spacing: 9) {
                        SFSymbol("archivebox.fill", false)
                            .font(.system(size: Types.title2))
                            .frame(height: Types.title2)

                        Text(LocalizedStringKey("Packages L"))
                            .font(.system(size: Types.callout).weight(.medium))
                            .lineLimit(1)
                    }
                }
                .padding(16)
                .foregroundColor(showPackageHome ? Color(.systemBackground) : .primary)
                .background(showPackageHome ? Color.accentColor : Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                .shadow(color: Color.black.opacity(showPackageHome ? (colorScheme == .dark ? 0.3 : 0.1) : (colorScheme == .dark ? 0.15 : 0.05)), radius: 11, y: 10)
            }
            .buttonStyle(CardButtonStyle())

            Button(action: {
                Haptics.shared.play(.light)

                withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                    showPackageHome = false
                    showRepoHome = true
                }
            }) {
                LeadingHStack {
                    VStack(alignment: .leading, spacing: 9) {
                        SFSymbol("tray.fill", false)
                            .font(.system(size: Types.title2))
                            .frame(height: Types.title2)

                        Text(LocalizedStringKey("Repos L"))
                            .font(.system(size: Types.callout).weight(.medium))
                            .lineLimit(1)
                    }
                }
                .padding(16)
                .foregroundColor(showRepoHome ? Color(.systemBackground) : .primary)
                .background(showRepoHome ? Color.accentColor : Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                .shadow(color: Color.black.opacity(showRepoHome ? (colorScheme == .dark ? 0.3 : 0.1) : (colorScheme == .dark ? 0.15 : 0.05)), radius: 11, y: 10)
            }
            .buttonStyle(CardButtonStyle())
        }
    }
}
