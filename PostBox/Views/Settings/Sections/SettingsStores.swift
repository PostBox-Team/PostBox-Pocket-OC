//
//  SettingsStores.swift
//  PostBox
//
//  Created by b0kch01 on 4/17/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsStores: View {
    
    @EnvironmentObject var repoManager: RepoManager
    @Environment(\.colorScheme) var colorScheme
    
    @State var marketRepos = [String: Repo]()
    @State var refreshingStores = false
    
    /// Haha
    static var storedStores = [String]()
    
    private func refreshInfo() {
        marketRepos.keys.forEach {
            marketRepos[$0] = repoManager.repos[$0]
        }
    }
    
    private func refreshAll(force: Bool?=false, completion: (() -> Void)?=nil) {
        if refreshingStores && !force! { return }
        
        refreshingStores = true
        
        let group = DispatchGroup()
        
        /// Updates the list
        repoManager.repos.values.forEach { repo in
            group.enter()
            repo.loadMarket(group: group) {
                SettingsStores.storedStores.append(repo.url)
                marketRepos[repo.url] = repo
                if repo.loggedIn {
                    repo.getUserInfo(group: group) {
                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion?()
            refreshingStores = false
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 7) {
                SectionHeader("Signed In L")
                    .padding(.horizontal, UIConstants.margin)
                
                VStack(spacing: 0) {
                    ForEach(Array(marketRepos.values).sorted()) { repo in
                        StoreListItem(repo: repo)
                        .contextMenu(ContextMenu(menuItems: {
                            repo.contextMenu
                        }))
                        
                        Bar()
                            .padding(.leading, 61)
                            .padding(.horizontal, UIConstants.margin)
                    }
                }
            }
            .padding(.vertical, UIConstants.margin)
        }
        .navigationBarTitle(LocalizedStringKey("Stores L"), displayMode: .inline)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .pullToRefresh(isShowing: $refreshingStores) {
            refreshAll(force: true)
        }
        .onAppear {
            if !LazyImplementationOfStore.loaded {
                LazyImplementationOfStore.loaded = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    refreshAll {
                        SettingsStores.storedStores = Array(marketRepos.keys)
                    }
                }
            } else {
                SettingsStores.storedStores.forEach {
                    marketRepos[$0] = repoManager.repos[$0]
                }
            }
        }
    }
}
