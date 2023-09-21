//
//  SettingsRepo.swift
//  Pocket
//
//  Created by Polarizz on 9/12/22.
//  Copyright © 2022 PostBox Team. All rights reserved.
//

import SwiftUI

struct SettingsRepo: View {
    
    @EnvironmentObject var repoManager: RepoManager
    
    @State private var alertRestoreRepos = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                main
                
                remove
                                                                
                Spacer()
            }
            .padding(UIConstants.margin)
        }
        .navigationBarTitle(LocalizedStringKey("Repos L"), displayMode: .inline)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
    
    private var main: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader("Refresh LU")
            
            VStack(spacing: 16) {
                SettingsCardToggle(
                    title: "Refresh Repo On Launch L",
                    desc: "PostBox will refresh installed repos on app launch. L",
                    key: "setting-auto-refresh",
                    short: "Auto Refresh",
                    disabled: false
                )
            }
            .settingsSectionStyle()
        }
    }
    
    private var remove: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader("Reset LU")
            
            VStack(spacing: 16) {
                Button(action: {
                    alertRestoreRepos = true
                }) {
                    SettingsCardOption(
                        title: "Remove All Repos L",
                        symbol: "xmark.app.fill",
                        color: .red
                    )
                }
                .buttonStyle(DefaultButtonStyle())
                .alert(isPresented: $alertRestoreRepos) {
                    Alert(
                        title: Text("Restore to default repos"),
                        message: Text("You may lose all \(RepoManager.reposCached.count) repos. Do you want to continue?"),
                        primaryButton: .destructive(Text("Restore"), action: {
                            RepoManager.reposCached = [:]
                            repoManager.sync(with: .static) {
                                repoManager.addRepo(urls: RepoManager.defaultRepos) {
                                    log("🗑 Repos restored!")
                                }
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
