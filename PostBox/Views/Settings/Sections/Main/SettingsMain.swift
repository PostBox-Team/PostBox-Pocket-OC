//
//  SettingsTheme.swift
//  PostBox
//
//  Created by Polarizz on 5/15/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsMain: View {
    var body: some View {
        VStack(spacing: 16) {
            SettingsOption(
                symbol: "gearshape.2.fill",
                title: "General L",
                desc: "Main app settings L",
                custom: true
            ) {
                SettingsGeneral()
            }
            
            Bar()
                .padding(.leading, Types.title3 + 31)

            SettingsOption(
                symbol: "archivebox.fill",
                title: "Packages L",
                desc: "Package settings L",
                custom: false
            ) {
                SettingsPackage()
            }
            
            Bar()
                .padding(.leading, Types.title3 + 31)

            SettingsOption(
                symbol: "tray.fill",
                title: "Repos L",
                desc: "Repo settings L",
                custom: false
            ) {
                SettingsRepo()
            }
        }
        .settingsSectionStyle()
    }
}
