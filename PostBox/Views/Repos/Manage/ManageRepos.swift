//
//  ManageRepos.swift
//  PostBox
//
//  Created by b0kch01 on 11/11/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh

struct ManageRepos: View {
    
    @EnvironmentObject var repoManager: RepoManager
    @EnvironmentObject var packageManager: PackageManager
    
    @State var progress = [String: Double]()
    @State var states = [String: PackageManager.RefreshState]()
    
    @State var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
        
    // Input for new repo url
    @State var spin = false
    @State var showingImport = false
    @State var showingExport = false
    @State var showAddView = false
    @State var alertPaste = false
    
    // Pop-up
    @State private var manageOptions = false
    
    let preferredLanguage = NSLocale.preferredLanguages[0]
    
    var body: some View {
        installedRepoList
    }
    
    private var installedRepoList: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if preferredLanguage == "zh-Hans" {
                    SectionHeaderNoLocalization("添加了" + String(repoManager.repos.count) + "个软体源")
                } else if preferredLanguage == "zh-Hant" {
                    SectionHeaderNoLocalization("添加了" + String(repoManager.repos.count) + "個軟體源")
                } else {
                    SectionHeaderNoLocalization(String(repoManager.repos.count) + (repoManager.repos.count == 1 ? " Repo" : " Repos") + " Added")
                }
                
                Spacer()
                    
                Button(action: { showingExport.toggle() }) {
                    Image(systemName: "arrow.up.doc.on.clipboard")
                        .font(.system(size: Types.body))
                        .foregroundColor(.secondary)
                }
                .alert(isPresented: $showingExport) {
                    Alert(
                        title: Text(LocalizedStringKey("Export Repos L")),
                        message:
                            preferredLanguage == "zh-Hans" ?
                            Text("你即将把\(repoManager.repos.count)个软体源导出到粘贴板") :
                            (
                                preferredLanguage == "zh-Hant" ?
                                Text("你即將吧\(repoManager.repos.count)个軟體源導出到黏貼版") :
                                Text(repoManager.repos.count == 1 ? "You are about to export \(repoManager.repos.count) repo to the Pasteboard." : "You are about to export \(repoManager.repos.count) repos to the Pasteboard.")
                            )
                        ,
                        primaryButton: Alert.Button.default(Text(LocalizedStringKey("Export L")), action: {
                        UIPasteboard.general.string = repoManager.repos.values.map { $0.url + "\n" }.reduce("", +)
                    }),
                        secondaryButton: Alert.Button.cancel()
                    )
                }
                
                Button(action: { showingImport.toggle() }) {
                    Image(systemName: "plus")
                        .font(.system(size: Types.body + 2))
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)
                }
                .sheet(isPresented: $showingImport) {
                    ImportReposView(showingImport: $showingImport)
                        .environmentObject(repoManager)
                        .environmentObject(packageManager)
                }
            }
            .padding(.horizontal, UIConstants.margin)
            .padding(.top, 21)
            .padding(.bottom, 13)
            
            if repoManager.repos.count != 0 {
                VStack(spacing: 0) {
                    ForEach(Array(repoManager.repos.values).sorted()) { repo in
                        NavigationLink(destination: BrowseRepo(repo)) {
                            HStack(alignment: .center, spacing: 0) {
                                repo.iconViewCard
                                    .frame(width: 45, height: 45)
                                    .background(Color(.quaternarySystemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: Repo.appCornerRadius(width: 45), style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Repo.appCornerRadius(width: 45), style: .continuous)
                                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                            .opacity(0.3)
                                    )
                                    .padding(.trailing, 16)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(repo.name)
                                        .font(.system(size: Types.callout))
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    
                                    Text(repo.urlNoProtocol)
                                        .font(.system(size: Types.subheadline))
                                        .fontWeight(.regular)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                                
                                Button(action: {
                                    Haptics.shared.play(.light)
                                    
                                    DispatchQueue.main.async {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 1)) {
                                            if !packageManager.working {
                                                repoManager.removeRepo(url: repo.url)
                                                PackageManager.packagesByRepo.removeValue(forKey: repo.url)
                                                PackageManager.packages = PackageManager.packages.filter({ repoManager.repos[$0.value.repoURL] != nil })
                                            }
                                        }
                                    }
                                }) {
                                    if !packageManager.working {
                                        Image("xmark.app.fill")
                                            .foregroundColor(.red)
                                            .font(.system(size: Types.title2))
                                            .transition(.scale)
                                    } else {
                                        RepoProgressCircle(finishedAll: $packageManager.working, progress: $progress, state: $states, id: repo.url)
                                            .transition(.scale)
                                    }
                                }
                                .buttonStyle(DefaultButtonStyle())
                                .padding(.trailing, 5)
                                .animation(.spring(response: 0.3, dampingFraction: 1), value: packageManager.working)
                            }
                            .padding(.vertical, 11)
                            .padding(.horizontal, UIConstants.margin)
                            .background(Color.primaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        }
                        .buttonStyle(NoButtonStyle())
                        .contextMenu(ContextMenu(menuItems: {
                            repo.contextMenu
                        }))
                        
                        Bar()
                            .padding(.leading, 61)
                            .padding(.horizontal, UIConstants.margin)
                    }
                }
            } else {
                NullCard(
                    symbol: "tray",
                    title: "No Repos Added L",
                    desc: "Add repos to see recently updated packages. L",
                    custom: false
                )
                .padding(.horizontal, UIConstants.margin)
            }
        }
    }
}

struct ManageReposModalQueue: View {
    
    @EnvironmentObject var repoManager: RepoManager
    @EnvironmentObject var packageManager: PackageManager
    
    @State var progress = [String: Double]()
    @State var states = [String: PackageManager.RefreshState]()
    
    @State var timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    let preferredLanguage = NSLocale.preferredLanguages[0]

    var body: some View {
        VStack(spacing: 0) {
            installedRepoList
        }
        .padding(.bottom, UIConstants.margin)
        .animation(.spring(response: 0.3, dampingFraction: 1), value: repoManager.repos)
        .onReceive(timer) { _ in
            if packageManager.working || repoManager.working {
                states = packageManager.refreshStates
                progress = self.packageManager.refreshProgress
                    .mapValues { progress in
                        return progress.fractionCompleted
                    }
            }
        }
    }

    private var installedRepoList: some View {
        VStack(spacing: 0) {
            Group {
                if preferredLanguage == "zh-Hans" {
                    SectionHeaderNoLocalization("添加了" + String(repoManager.repos.count) + "个软体源")
                } else if preferredLanguage == "zh-Hant" {
                    SectionHeaderNoLocalization("添加了" + String(repoManager.repos.count) + "個軟體源")
                } else {
                    SectionHeaderNoLocalization(String(repoManager.repos.count) + (repoManager.repos.count == 1 ? " Repo" : " Repos") + " Added")
                }
            }
            .padding(.horizontal, UIConstants.margin)
            .padding(.top, 19)
            .padding(.bottom, 13)
            
            if repoManager.repos.count != 0 {
                VerticalStack(spacing: 0) {
                    ForEach(Array(repoManager.repos.values).sorted()) { repo in
                        NavigationLink(destination: BrowseRepo(repo)) {
                            HStack(alignment: .center, spacing: 0) {
                                repo.iconViewCard
                                    .frame(width: 45, height: 45)
                                    .background(Color(.quaternarySystemFill))
                                    .clipShape(RoundedRectangle(cornerRadius: Repo.appCornerRadius(width: 45), style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Repo.appCornerRadius(width: 45), style: .continuous)
                                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                            .opacity(0.3)
                                    )
                                    .padding(.trailing, 16)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(repo.name)
                                        .font(.system(size: Types.callout))
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    
                                    Text(repo.urlNoProtocol)
                                        .font(.system(size: Types.subheadline))
                                        .fontWeight(.regular)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                                
                                Button(action: {
                                    Haptics.shared.play(.light)
                                    
                                    DispatchQueue.main.async {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 1)) {
                                            if !packageManager.working {
                                                repoManager.removeRepo(url: repo.url)
                                                PackageManager.packagesByRepo.removeValue(forKey: repo.url)
                                                PackageManager.packages = PackageManager.packages.filter({ repoManager.repos[$0.value.repoURL] != nil })
                                            }
                                        }
                                    }
                                }) {
                                    if !packageManager.working {
                                        Image("checkmark.app.fill")
                                            .foregroundColor(Color.accentColor)
                                            .font(.system(size: Types.title2))
                                            .transition(.scale)
                                    } else {
                                        RepoProgressCircle(finishedAll: $packageManager.working, progress: $progress, state: $states, id: repo.url)
                                            .transition(.scale)
                                    }
                                }
                                .buttonStyle(DefaultButtonStyle())
                                .padding(.trailing, 5)
                                .animation(.spring(response: 0.3, dampingFraction: 1), value: packageManager.working)
                            }
                            .padding(.vertical, 11)
                            .padding(.horizontal, UIConstants.margin)
                            .background(Color.primaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        }
                        .buttonStyle(NoButtonStyle())
                        .contextMenu(ContextMenu(menuItems: {
                            repo.contextMenu
                        }))
                        
                        Bar()
                            .padding(.leading, 61)
                            .padding(.horizontal, UIConstants.margin)
                    }
                }
            } else {
                NullCard(
                    symbol: "tray",
                    title: "No Repos Added L",
                    desc: "Add repos to see recently updated packages. L",
                    custom: false
                )
                .padding(.horizontal, UIConstants.margin)
            }
        }
    }
}
