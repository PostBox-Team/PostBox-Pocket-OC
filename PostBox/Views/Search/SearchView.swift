//
//  SearchView.swift
//  PostBox
//
//  Created by b0kch01 on 11/11/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SearchView: View {

    /// Max number of search results shown in view (`Repo` currently does not have a prefix)
    private let PACKAGE_PREFIX = 40
    private let REPO_PREFIX = 5
    
    @EnvironmentObject private var packageManager: PackageManager

    var search: String

    /// 0 - normal, 1 - contains, 2 - desc + author
    private var searchType: Int { Defaults.integer(forKey: "setting-search-mode") }
    
    private var packages: [Package] {
        if search == "" { return [Package]() }
        if searchType == 0 {
            return Array(
                PackageManager.packages.values
                    .filter { $0.name.lowercased().hasPrefix(search.lowercased()) }
                    .prefix(PACKAGE_PREFIX)
            )
        }
        if searchType == 1 {
            return Array(
                PackageManager.packages.values
                    .filter { $0.name.localizedCaseInsensitiveContains(search) }
                    .prefix(PACKAGE_PREFIX)
            )
        }

        return Array(
            PackageManager.packages.values
                .filter {
                    search != "" && $0.name.localizedCaseInsensitiveContains(search) ||
                    $0.author.name.localizedCaseInsensitiveContains(search) ||
                    $0.maintainer.name.localizedCaseInsensitiveContains(search) ||
                    $0.description.localizedCaseInsensitiveContains(search)
                }
                .prefix(PACKAGE_PREFIX)
        )
    }
    
    private var repos: [Repo] {
        if search == "" { return [Repo]() }
        if searchType == 0 {
            return Array(
                RepoManager.reposCached.values
                    .filter { $0.name.lowercased().hasPrefix(search.lowercased()) }
                    .prefix(REPO_PREFIX)
            )
        }
        if searchType == 1 {
            return Array(
                RepoManager.reposCached.values
                    .filter { $0.name.localizedCaseInsensitiveContains(search) }
                    .prefix(REPO_PREFIX)
            )
        }
        return Array(
            RepoManager.reposCached.values
                .filter {
                    $0.name.localizedCaseInsensitiveContains(search) ||
                    $0.url.localizedCaseInsensitiveContains(search)
                }
                .prefix(REPO_PREFIX)
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if repos.count == 0 && packages.count == 0 {
                SearchEmpty(searchInput: search)
            } else {
                ScrollView {
                    // Must stretch ScrollView
                    Divider().opacity(0)

                    VStack(spacing: 0) {
                        if repos.count > 0 {
                            SectionHeader("Repos L", listHeader: true)
                            ReposSection(repos: repos)
                        }
                        if packages.count > 0 {
                            SectionHeader("Packages L", listHeader: true)
                            PackagesSection(packages: packages)
                        }
                        // TODO: Find a way to update view when packages are done loading (when this view is destroyed)
                        if packageManager.working {
                            HStack(spacing: 10) {
                                ActivityIndicator()
                                Text("Packages are still loading...")
                            }
                        }
                    }
                }
            }
        }
        .background(
            Color.primaryBackground.edgesIgnoringSafeArea(.bottom)
        )
    }
}
