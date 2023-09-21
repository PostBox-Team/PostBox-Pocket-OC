//
//  SettingsAbout.swift
//  PostBox
//
//  Created by Polarizz on 12/9/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import BetterSafariView

struct SettingsAbout: View {
    
    @State var showingUpdatesSite = false
    @State var showingFAQSite = false
    @State var showingDonateSite = false
    
    var body: some View {
        VStack(spacing: 13) {
            Button(action: { showingDonateSite.toggle() }) {
                SettingsCardListLink(
                    symbol: "cup.and.saucer.fill",
                    title: "Donate L",
                    desc: "Buy us a Ko-fi L",
                    custom: true
                )
            }
            .buttonStyle(DefaultButtonStyle())
            .sheet(isPresented: $showingDonateSite) {
                NaiveSafariView(url: URLS.kofi)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .settingsSectionStyle()
    }
}
