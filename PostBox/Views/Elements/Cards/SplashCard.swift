//
//  SplashCard.swift
//  SplashCard
//
//  Created by Polarizz on 9/14/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SplashCard: View {

    @Environment(\.colorScheme) var colorScheme

    @State private var hidden: Bool

    private var cacheKey: String?
    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey
    private var dismissable: Bool
    
    init(_ title: LocalizedStringKey, _ desc: LocalizedStringKey, _ dismissable: Bool = true, cacheKey: String?=nil) {
        self.title = title
        self.desc = desc
        self.dismissable = dismissable
        self.cacheKey = cacheKey

        self._hidden = State(initialValue: Defaults.bool(forKey: cacheKey ?? "nothing"))
    }
    
    var body: some View {
        if !hidden {
            if dismissable {
                Button(action: {
                    Haptics.shared.play(.light)

                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        hidden = true
                    }

                    if let cacheKey = cacheKey {
                        Defaults.set(true, forKey: cacheKey)
                    }
                }) {
                    HStack(alignment: .center, spacing: 5) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(title)
                                .font(.system(size: Types.callout))
                                .fontWeight(.medium)

                            Text(desc)
                                .font(.system(size: Types.subheadline))
                                .fontWeight(.regular)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .foregroundColor(.secondary)

                        Spacer()

                        Image(systemName: "xmark")
                            .font(.system(size: Types.subheadline).weight(.medium))
                            .foregroundColor(Color(.tertiaryLabel))
                            .padding(.leading, 10)
                            .padding(.trailing, 3)
                    }
                    .padding(16)
                    .background(Color(.quaternarySystemFill).opacity(colorScheme == .dark ? 0.5 : 1))
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                }
                .buttonStyle(DefaultButtonStyle())
            }
        }
    }
}

struct UpdateCard: View {

    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var bannerManager: BannerManager

    @State private var showingUpdateSite = false
    
    var body: some View {
        Button(action: {
            showingUpdateSite = true
        }) {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(LocalizedStringKey("Update Available L"))
                        .font(.system(size: Types.callout).weight(.medium))
                        .foregroundColor(.primary)
                    
                    Text(LocalizedStringKey("Tap to download the new update"))
                        .font(.system(size: Types.subheadline).weight(.regular))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: Types.subheadline).weight(.medium))
                    .foregroundColor(Color(.tertiaryLabel))
                    .padding(.leading, 10)
                    .padding(.trailing, 3)
            }
            .padding(16)
            .background(Color(.quaternarySystemFill).opacity(colorScheme == .dark ? 0.5 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        }
        .buttonStyle(DefaultButtonStyle())
        .sheet(isPresented: $showingUpdateSite) {
            NaiveSafariView(url: URLFunction.cleanURL(bannerManager.newUpdateLink))
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}
