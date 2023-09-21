//
//  Repo.swift
//  PostBox
//
//  Created by b0kch01 on 11/9/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import URLImage

/// Struct representing a repository
class Repo: ObservableObject, Identifiable, Equatable, Comparable {
    static func < (lhs: Repo, rhs: Repo) -> Bool { lhs.name < rhs.name }
    static func == (lhs: Repo, rhs: Repo) -> Bool { lhs.id == rhs.id }
    
    /// Repo origin / label
    @Published var name: String
    @Published var description: String
    @Published var featured = DepictionObjectView("")
    @Published var market = RepoMarket()
    
    /// The source URL (includes protocol)
    var id: String
    /// URL to the icon (includes root)
    var icon: String
    var lastSynced = Date()
    
    /// All packages in a repo
    var all = [Package]()
                
    /// All packages ordered in sections (built in BrowseRepo)
    var sections = [String: [Package]]()
    
    init(url: String?=nil, name: String?=nil, description: String?=nil) {
        self.id          = url ?? UUID().uuidString
        self.name        = name ?? "Some Repo"
        self.description = description ?? "A package repository"
        self.icon        = "error_placeholder"
    }
    
    init(url: String, repoString: String) {
        self.id          = url
        self.name        = Package.getRow(repoString, field: "Origin") ?? "Some Repo"
        self.description = Package.getRow(repoString, field: "Description") ?? "A package reposition"
        self.icon        = URLFunction.join(url, "CydiaIcon.png")
    }
    
    var url: String { id }
    /// Returns the url without the protocol and lowercased. Only use for UI purposes
    var urlNoProtocol: String { url.lowercased().replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "") }
    var iconURL: String {
        if url.hasPrefix("http://apt.thebigboss.org/repofiles/cydia") {
            return URLFunction.join(url, "/dists/stable/CydiaIcon.png")
        }
        return URLFunction.join(url, "CydiaIcon.png")
    }
    /// If the user is logged into the repo store
    var loggedIn: Bool {
        LazyImplementationOfStore.tokens[url]?.count ?? 0 > 0
    }
    
    // MARK: - Functions
    
    func merge(with newRepo: Repo) {
        self.id          = newRepo.id
        self.name        = newRepo.name
        self.description = newRepo.description
        self.featured    = newRepo.featured
        self.icon        = newRepo.icon
        self.lastSynced  = newRepo.lastSynced
        self.all         = newRepo.all
        self.sections    = newRepo.sections
        self.market      = newRepo.market
    }
    
    @ViewBuilder var contextMenu: some View {
        
        Divider()
        
        Button(action: {
            UIPasteboard.general.string = self.url
        }) {
            Image(systemName: "doc.on.clipboard")
            Text("Copy source")
        }
    }
}
