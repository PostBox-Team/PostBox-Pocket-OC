//
//  HomeView.swift
//  PostBox
//
//  Created by Polarizz on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import SwiftlySearch

struct HomeView: View {
    
    @EnvironmentObject var repoManager: RepoManager
    @EnvironmentObject var packageManager: PackageManager
    @EnvironmentObject var sceneManager: SceneManager
    
    @State private var searchActivated = false
    @State private var searchText = ""
    
    let preferredLanguage = NSLocale.preferredLanguages[0]
    
    var body: some View {
        NavigationView {
            HomeViewInner()
                .navigationBarSearch(
                    $searchText,
                    placeholder: preferredLanguage == "zh-Hans" ? "搜索" : (preferredLanguage == "zh-Hant" ? "搜索" : "Search"),
                    hidesSearchBarWhenScrolling: false,
                    cancelClicked: {
                        searchText = ""
                        withAnimation(.spring(response: 0.3, dampingFraction: 1)) {
                            searchActivated = false
                        }
                    },
                    resultContent: { _ in
                        SearchView(search: searchText)
                            .environmentObject(packageManager)
                            .environmentObject(repoManager)
                            .environmentObject(sceneManager)
                            .onAppear {
                                withAnimation(.spring(response: 0.25, dampingFraction: 1)) {
                                    searchActivated = true
                                }
                            }
                    }
                )
                .overlay(
                    SearchEmpty()
                        .opacity(searchActivated ? 1 : 0)
                )
        }
    }
}
