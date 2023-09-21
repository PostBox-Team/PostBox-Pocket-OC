//
//  SettingsCustomization.swift
//  PostBox
//
//  Created by Polarizz on 12/9/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsPackage: View {
    
    @State private var showTimeMode = false
    @State private var timeType = Defaults.integer(forKey: "setting-time-style")
    
    private let timeLabels = ["Elapsed", "Date"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                packages
                
                packagesColor
                                                
                Spacer()
            }
            .padding(UIConstants.margin)
        }
        .navigationBarTitle(LocalizedStringKey("Packages L"), displayMode: .inline)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
    
    private var packagesColor: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader("Depictions LU")
            
            VStack(spacing: 16) {
                SettingsCardToggle(
                    title: "Adaptive Color Depictions L",
                    desc: "Dynamically changes package depiction UI colors for support packages. L",
                    key: "setting-colorful-depicts",
                    short: "Colored Depictions",
                    disabled: false
                )
                
                Bar()
                
                SettingsCardToggle(
                    title: "Accelerated Depiction Rendering L",
                    desc: "Allows for faster package depiction loading. Turning this on will disable depiction text selection. L",
                    key: "setting-enable-fast-depicts",
                    short: "Faster Depictions",
                    disabled: false
                )
            }
            .settingsSectionStyle()
        }
    }
    
    private func setTimeSettings(_ mode: Int) {
        HomeViewModel.shared.setTimeStyle(mode)
        timeType = mode
        showTimeMode = false
    }
    
    private var packages: some View {
        VStack(alignment: .leading, spacing: 16) {
            SettingsSectionHeader("Packages LU")
            
            HStack(spacing: 5) {
                SettingsCardTextOption(
                    "Update Time Mode L",
                    "Choose between time elapsed or date format for updated packages in Home View. L"
                )
                
                Spacer()
                
                Button(action: { showTimeMode = true }) {
                    Text(LocalizedStringKey((timeLabels[timeType] + " L")))
                        .font(.system(size: Types.subheadline).weight(.regular))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 7)
                        .background(Color(.quaternarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                }
                .buttonStyle(DefaultButtonStyle())
                .actionSheet(isPresented: $showTimeMode) {
                    ActionSheet(
                        title: Text(LocalizedStringKey("Select an update time mode L")),
                        message: Text(LocalizedStringKey("Choose between time elapsed or date format for updated packages in Home View. L")),
                        buttons: [
                            .cancel(),
                            .default(Text(LocalizedStringKey("Elapsed L"))) { setTimeSettings(0) },
                            .default(Text(LocalizedStringKey("Date L"))) { setTimeSettings(1) },
                        ]
                    )
                }
            }
            .settingsSectionStyle()
        }
    }
}
