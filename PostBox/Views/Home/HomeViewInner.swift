//
//  HomeViewInner.swift
//  PostBox
//
//  Created by Polarizz on 8/29/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct HomeViewInner: View {
    
    @EnvironmentObject var repoManager: RepoManager
    @EnvironmentObject var packageManager: PackageManager
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var bannerManager: BannerManager
        
    @State var refreshing: Bool = false
    @State var progress: Double = 0
    
    @State private var showPackageHome = true
    @State private var showRepoHome = false
    @State private var counter: Int = 0
    
    let preferredLanguage = NSLocale.preferredLanguages[0]
    
    func refresh(startup: Bool?=false, done: (() -> Void)?=nil) {
        if startup! {
            withAnimation(.easeOut(duration: 0.39)) {
                refreshing = false
            }
        } else {
            if packageManager.working { return }
            
            withAnimation(.easeOut(duration: 0.39)) {
                refreshing = false
            }
        }
        
        progress = 0
        
        let group = DispatchGroup()
        
        group.enter()
        if startup! {
            packageManager.getVersionHistory {
                withAnimation(.spring(response: 0.39, dampingFraction: 1)) { progress += 2 }
                group.leave()
            }
        } else {
            packageManager.refreshRepos {
                withAnimation(.spring(response: 0.39, dampingFraction: 1)) { progress += 1 }
                packageManager.getVersionHistory {
                    withAnimation(.spring(response: 0.39, dampingFraction: 1)) { progress += 1 }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            done?()
            withAnimation(.easeOut(duration: 0.39)) {
                refreshing = false
            }
        }
    }
    
    var body: some View {
        RefreshableScrollView(
            image: "arrow.triangle.2.circlepath",
            onRefresh: { refresh(done: $0) }
        ) {
            if #available(iOS 15, *) {
                homeContent
                    .padding(.bottom, UIConstants.margin)
            } else {
                homeContent
                    .padding(.vertical, UIConstants.margin)
            }
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            leading:
                Group {
                    if #available(iOS 14.0, *) {
                        Image("launcherBold").resizable()
                            .frame(
                                width: Types.title2,
                                height: Types.title2
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                Haptics.shared.play(.light)
                                counter += 1
                            }
                            .confettiCannon(
                                counter: $counter, confettis: [.sfSymbol(symbolName: "heart.fill")],
                                colors: [Color.accentColor],
                                rainHeight: UIScreen.main.bounds.maxY,
                                openingAngle: Angle(degrees: 270),
                                closingAngle: Angle(degrees: 0), radius: 300
                            )
                    } else {
                        Image("launcherBold").resizable()
                            .frame(
                                width: Types.title2,
                                height: Types.title2
                            )
                    }
                }
                .zIndex(9999)
            ,
            trailing:
                NavigationBarItems()
        )
        .onAppear {
            refresh(startup: true)
        }
    }
    
    @ViewBuilder
    private var homeContent: some View {
        VStack(spacing: 0) {
            if bannerManager.newUpdate {
                UpdateCard()
                    .padding(.horizontal, UIConstants.margin)
                    .padding(.bottom, 13)
            }
            
            HomePlatter(
                showPackageHome: $showPackageHome,
                showRepoHome: $showRepoHome
            )
            .padding(.horizontal, UIConstants.margin)
            .zIndex(10)
            
            if showPackageHome {
                if refreshing || packageManager.working {
                    HomeLoadingCard(progress: $progress)
                        .padding(.top, 9)
                } else if packageManager.versionHistory.count < 1 {
                    HomeNullCard()
                        .padding(.top, 9)
                } else {
                    HomeViewRecents()
                }
            } else if showRepoHome {
                ManageRepos()
            }
     
            // SceneManager Views (URL)
            NavigationLink(
                destination: PackageView(sceneManager.destPackage),
                tag: NavigateType.package, selection: $sceneManager.navigateType
            ) { EmptyView() }
            NavigationLink(
                destination: BrowseRepo(sceneManager.destRepo),
                tag: NavigateType.repo, selection: $sceneManager.navigateType
            ) { EmptyView() }
        }
        .animation(.spring(), value: packageManager.working)
    }
}
