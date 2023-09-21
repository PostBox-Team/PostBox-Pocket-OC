//
//  RepoNotAdded.swift
//  PostBox
//
//  Created by b0kch01 on 1/31/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct RepoNotAdded: View {

    @EnvironmentObject var repoManager: RepoManager
    @EnvironmentObject var packageManager: PackageManager
    
    @ObservedObject var repo: Repo

    // Loading packages things
    @Binding var progress: [String: Double]
    @Binding var states: [String: PackageManager.RefreshState]
    
    @State var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    var body: some View {
        Button(action: {
            repoManager.addRepo(url: repo.url) {
                packageManager.refreshRepo(for: repo.url)
            }
        }) {
            WarningCard(
                link: repo.url,
                text: " added and refreshed in order to view repository.",
                symbol: "plus"
            )
            .padding(.horizontal, UIConstants.margin)
            .onReceive(timer) { _ in
                if packageManager.working {
                    states = packageManager.refreshStates
                    progress = packageManager.refreshProgress
                        .mapValues { progress in
                            return progress.fractionCompleted
                        }
                }
            }
        }
        .buttonStyle(DefaultButtonStyle())
        .disabled(packageManager.working)
    }
}
