//
//  SettingsGeneral.swift
//  PostBox
//
//  Created by Polarizz on 1/4/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import URLImage

struct SettingsGeneral: View {

    @State private var accentColor = Color.primary
    
    @State private var type = Defaults.integer(forKey: "setting-search-mode")
    @State private var showSearchMode = false
    @State private var alertResetSettings = false

    private let typeLabels = ["Classic", "Contains", "Deep"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                customization

                display
                
                searchSettings
                
                reset
                
                Spacer()
            }
            .padding(UIConstants.margin)
        }
        .navigationBarTitle(LocalizedStringKey("General L"), displayMode: .inline)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
    
    private var customization: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader("customization LU")
            
            VStack(spacing: 16) {
                NavigationLink(destination: SettingsAppIcon()) {
                    SettingsCardMore(
                        title: "App Icon L",
                        desc: "Choose a custom app icon for your device's home screen. L"
                    )
                }
                .buttonStyle(DefaultButtonStyle())
            }
            .settingsSectionStyle()
        }
    }
    
    private var display: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader("Display LU")
            
            VStack(spacing: 16) {
                SettingsCardToggle(
                    title: "Icon Rendering L",
                    desc: "Renders package and repository icons. L",
                    key: "setting-enable-icon-rendering",
                    short: "Icon Rendering",
                    disabled: false
                )
            }
            .settingsSectionStyle()
        }
    }
    
    private func setSearchSetting(_ mode: Int) {
        Defaults.set(mode, forKey: "setting-search-mode")
        type = mode
        showSearchMode = false
    }
    
    private var searchSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader("Search LU")
            
            HStack(spacing: 5) {
                SettingsCardTextOption(
                    "Search Mode L",
                    "Search results with titles that contain the search term. L"
                )
                
                Spacer()
                
                Button(action: { showSearchMode = true }) {
                    Text(LocalizedStringKey(typeLabels[type] + " L"))
                        .font(.system(size: Types.subheadline).weight(.regular))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 7)
                        .background(Color(.quaternarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                }
                .buttonStyle(DefaultButtonStyle())
                .actionSheet(isPresented: $showSearchMode) {
                    ActionSheet(
                        title: Text(LocalizedStringKey("Select a search mode L")),
                        message: Text(LocalizedStringKey("Search results with titles that contain the search term. L")),
                        buttons: [
                            .cancel(),
                            .default(Text(LocalizedStringKey("Classic L"))) { setSearchSetting(0) },
                            .default(Text(LocalizedStringKey("Contains L"))) { setSearchSetting(1) },
                            .default(Text(LocalizedStringKey("Deep L"))) { setSearchSetting(2) }
                        ]
                    )
                }
            }
            .settingsSectionStyle()
        }
    }
    
    private var reset: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader("Reset LU")
            
            VStack(spacing: 16) {
                Button(action: {
                    URLImageService.shared.cleanup()
                    
                    Defaults.dictionaryRepresentation().keys.forEach {
                        if
                            URLFunction.valid($0) ||
                                $0.hasPrefix("version-history") ||
                                $0.hasPrefix("latest-versions")
                        {
                            Defaults.set(nil, forKey: $0)
                        }
                    }
                    log("🗑 Cache cleared!")
                }) {
                    SettingsCardOption(
                        title: "Clear Cache L",
                        symbol: "xmark.app.fill",
                        color: .primary
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(DefaultButtonStyle())
                
                Bar()
                                
                Button(action: { alertResetSettings = true }) {
                    SettingsCardOption(
                        title: "Reset All Settings L",
                        symbol: "xmark.app.fill",
                        color: .red
                    )
                }
                .buttonStyle(DefaultButtonStyle())
                .alert(isPresented: $alertResetSettings) {
                    Alert(
                        title: Text("Do you want to reset all settings?"),
                        message: Text("This action cannot be undone and app will relaunch."),
                        primaryButton: .destructive(Text("Reset"), action: {
                            SettingsManager.restoreAll()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                                       to: UIApplication.shared, for: nil)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { exit(0) }
                            }
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
            .settingsSectionStyle()
        }
    }
}
