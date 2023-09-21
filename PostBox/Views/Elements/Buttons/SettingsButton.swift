//
//  SettingsButton.swift
//  PostBox
//
//  Created by Polarizz on 10/6/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsButton: View {
    
    @EnvironmentObject var repoManager: RepoManager
    @EnvironmentObject var packageManager: PackageManager
    
    @State private var showingSettings = false
    
    var body: some View {
        Button(action: {
            showingSettings = true
        }) {
            Image(systemName: "arrow.down")
                .font(.system(size: UIConstants.footnote).weight(.medium))
                .frame(width: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
                .foregroundColor(.clear)
                .padding(7)
                .background(Color(.tertiarySystemBackground))
                .overlay(
                    Image(systemName: "ellipsis")
                        .font(.system(size: UIConstants.footnote).weight(.medium))
                        .frame(width: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
                        .foregroundColor(.primary)
                )
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                        .opacity(0.25)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(CardButtonStyle())
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(repoManager)
                .environmentObject(packageManager)
        }
    }
}
