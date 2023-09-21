//
//  SettingsView.swift
//  PostBox
//
//  Created by Polarizz on 11/9/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var packageManager: PackageManager

    @ObservedObject var color = uiConstants
            
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SplashHeader("Settings L")
                    .padding(.horizontal, UIConstants.margin)
                
                ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        SettingsMain()
                        
                        SettingsPackageRepo()
                        
                        SettingsDebug()
                          
                        //SettingsAbout()
                        
                        Spacer()
                    }
                    .padding(UIConstants.margin)
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .large)
            .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .accentColor(Color.primary)
        .onDisappear {
            hideKeyboard()
        }
    }
}
