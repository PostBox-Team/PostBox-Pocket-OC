//
//  SettingsDebug.swift
//  PostBox
//
//  Created by Polarizz on 5/15/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsDebug: View {
    var body: some View {
        VStack(spacing: 16) {
            SettingsOption(
                symbol: "terminal.fill",
                title: "App Log L",
                desc: "View app actions L",
                custom: true
            ) {
                Log()
            }
            
//            Bar()
//                .padding(.leading, Types.title3 + 31)

//            SettingsOption(
//                symbol: "exclamationmark.bubble.fill",
//                title: "Report L",
//                desc: "Send App Logs, issues, and feedback L",
//                custom: true
//            ) {
//                ReportView()
//            }
        }
        .settingsSectionStyle()
    }
}
