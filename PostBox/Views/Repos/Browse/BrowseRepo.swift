//
//  TweaksInRepo.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 6/6/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import URLImage

struct BrowseRepo: View {
    
    @EnvironmentObject var packageManager: PackageManager
    @EnvironmentObject var repoManager: RepoManager

    @ObservedObject var repo: Repo
    
    // Repo things
    @State var all = [Package]()
    @State var sections = [String: [Package]]()
    @State var timeSync = Date.distantPast

    // Store things
    @State var showBanner = false
    @State var loggedIn = false

    // Progress things
    @State var progress = [String: Double]()
    @State var states = [String: PackageManager.RefreshState]()

    // Paging
    @State private var page = 0
    
    @State private var appRadius: CGFloat = 90
            
    init(_ repo: Repo) {
        self.repo = repo
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                repoHeader
                    .padding(.bottom, 16)
                    .padding(.horizontal, UIConstants.margin)

                if showBanner {
                    SignInButton(repo: repo, loggedIn: $loggedIn)
                        .padding(.bottom, 16)
                        .padding(.horizontal, UIConstants.margin)
                }
                
                if let banners: [FeaturedBanner] = repo.featured.banners {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(banners.indices, id: \.self) { page in
                                if let url = URL(string: banners[page].url) {
                                    FeaturedPackageBanner(repo: repo, banner: banners[page], url: url)
                                }
                            }
                        }
                        .padding(.horizontal, UIConstants.margin)
                        .padding(.vertical, 40)
                    }
                    .zIndex(10)
                    .padding(.vertical, -40)
                    .padding(.bottom, 20)
                }

                if PackageManager.packagesByRepo[repo.id]?.count ?? 0 > 0 {
                    NavigationLink(destination: PackagesList(packages: all, title: "All Packages")) {
                        BrowseRepoSection(name: "All Packages", count: all.count, icon: true)
                    }
                    .background(Color(.quaternarySystemFill))
                    .onAppear {
                        if repo.lastSynced != packageManager.lastUpdated || repo.all.count == 0 {
                            var allTemp = [Package]()
                            var sectionsTemp = [String: [Package]]()

                            if let packages = PackageManager.packagesByRepo[repo.url] {
                                for package in packages {
                                    let category = package.section
                                    if category.count > 0 {
                                        if sectionsTemp[category] == nil {
                                            sectionsTemp[category] = [Package]()
                                        }
                                        sectionsTemp[category]!.append(package)
                                    }
                                    allTemp.append(package)
                                }
                            }

                            all = allTemp.sorted()
                            sections = sectionsTemp.mapValues { $0.sorted() }

                            repo.all = all
                            repo.sections = sections
                            repo.lastSynced = packageManager.lastUpdated

                        } else {
                            all = repo.all
                            sections = repo.sections
                        }
                    }

                    ForEach(Array(sections.keys).sorted(), id: \.self) { sectionName in
                        VStack(spacing: 0) {
                            NavigationLink(destination: PackagesList(packages: self.sections[sectionName]!, title: sectionName)) {
                                BrowseRepoSection(name: sectionName, count: sections[sectionName]!.count, icon: false)
                            }
                            
                            Bar().padding(.leading, UIConstants.margin*1.1)
                        }
                    }
                } else {
                    RepoNotAdded(repo: repo, progress: $progress, states: $states)
                }
            }
            .padding(.top, UIConstants.margin)
            .padding(.bottom, 100)
        }
        .animation(.spring(response: 0.39, dampingFraction: 0.9), value: repo.featured.banners)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            trailing:
               NavigationBarItems()
        )
        .onAppear {
            if repo.featured.banners == nil,
               let url = URL(string: URLFunction.join(repo.url, "sileo-featured.json")) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return log("❌ No featured data from: \(url.absoluteURL)")
                    }
                    
                    if let featured = try? JSONDecoder().decode(DepictionObjectView.self, from: data) {
                        repo.featured = featured
                        log("🌌 Loaded featured.")
                    }
                }.resume()
            }

            repo.loadMarket {
                withAnimation(.spring(response: 0.39, dampingFraction: 0.9)) {
                    showBanner = true
                }
            }
            
            if repo.loggedIn {
                withAnimation(.spring(response: 0.39, dampingFraction: 0.9)) {
                    showBanner = true
                    loggedIn = true
                }
            }
        }
    }
    
    @ViewBuilder
    private var repoHeader: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                repo.iconView
                    .frame(width: appRadius, height: appRadius)
                    .clipShape(RoundedRectangle(cornerRadius: Repo.appCornerRadius(width: appRadius), style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: Repo.appCornerRadius(width: appRadius), style: .continuous)
                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                            .opacity(0.3)
                    )
                    .contextMenu(menuItems: { repo.contextMenu })
                    .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 0) {
                    Text(repo.name)
                        .font(.system(size: Types.title2+3))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(repo.description)
                        .foregroundColor(.secondary)
                        .font(.system(size: Types.callout))
                        .padding(.top, 5)
                }
            }
            
            Spacer()
        }
    }
}
