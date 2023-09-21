//
//  ImportReposView.swift
//  PostBox
//
//  Created by Polarizz on 2/1/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ImportReposView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var repoManager: RepoManager
    @EnvironmentObject var packageManager: PackageManager
    
    @Binding var showingImport: Bool

    @State private var repoQueue = [Repo]()
    @State private var pasteboardOption = false
    @State private var addRepoText = ""

    let repoIconPreviewSize: CGFloat = 24
    
    @ViewBuilder
    private var repoIconPreview: some View {
        if addRepoText != "" {
            Repo(url: URLFunction.clean(addRepoText))
                .iconViewLoading
                .frame(
                    width: repoIconPreviewSize,
                    height: repoIconPreviewSize
                )
                .cornerRadius(repoIconPreviewSize * 0.2239)
                .transition(.scale)
        }
    }
    
    private var manageRepoSearchBar: some View {
        HStack(spacing: 5) {
            repoIconPreview
            
            TextField(LocalizedStringKey("Enter repo URL L"), text: $addRepoText)
                .font(.system(size: Types.body))
                .keyboardType(.URL)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.vertical, 11)
                .padding(.leading, 5)
                .accentColor(Color.primary)
        }
        .padding(.leading, 11)
        .padding(.trailing, 13)
        .background(Color(.quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        Text(LocalizedStringKey("Add or Import Repos L"))
                            .font(.title.weight(.bold))
                            .multilineTextAlignment(.center)
                            .padding(40)
                            .padding(.top, 30)
                        
                        VStack(alignment: .center, spacing: 13) {
                            manageRepoSearchBar
                        }
                        .padding(.horizontal, UIConstants.margin)
                        .padding(.bottom, 13)
                        
                        Button(action: {
                            Haptics.shared.play(.light)
                            
                            DispatchQueue.main.async {
                                withAnimation(Animation.spring(response: 0.3, dampingFraction: 1)) {
                                    pasteboardOption.toggle()
                                    
                                    if pasteboardOption {
                                        repoQueue = ImportRepos.getPasteboardSources()
                                    } else {
                                        repoQueue = []
                                    }
                                }
                            }
                        }) {
                            ListOptionCardToggle(
                                name: "Import from Pasteboard L",
                                desc: "Copy a list of repos to get started. L",
                                symbol: pasteboardOption ? "plus.app.fill" : "app",
                                foreground: pasteboardOption ? Color.accentColor : Color(.tertiaryLabel),
                                background: pasteboardOption ? (colorScheme == .dark ? Color(.tertiaryLabel) : Color.secondaryBackground) : Color(.quaternarySystemFill),
                                shadow: pasteboardOption ? true : false,
                                disabled: false
                            )
                        }
                        .buttonStyle(DefaultButtonStyle())
                        .padding(.horizontal, UIConstants.margin)
                        
                        Bar()
                            .padding(UIConstants.margin)
                        
                        if pasteboardOption {
                            ImportReposQueue(sources: $repoQueue)
                        }
                    }
                    .padding(.bottom, 80)
                }
                                
                LongButton(
                    text: "Cancel",
                    foreground: .primary,
                    background: Color(.quaternarySystemFill),
                    compact: false
                )
                .opacity(0)
                .padding([.horizontal, .bottom], UIConstants.margin)
            }
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .large)
            .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            .overlay(Grabber(), alignment: .top)
            .overlay(
                VStack(spacing: 0) {
                    LinearGradient(colors: [Color.primaryBackground, Color.primaryBackground.opacity(0)], startPoint: .bottom, endPoint: .top)
                        .padding(.horizontal, UIConstants.margin)
                        .frame(height: 80)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            showingImport = false
                        }) {
                            LongButton(
                                text: "Cancel L",
                                foreground: .primary,
                                background: Color(.quaternarySystemFill),
                                compact: false
                            )
                        }
                        .buttonStyle(DefaultButtonStyle())
                        
                        
                        Button(action: {
                            repoManager.addRepo(urls: repoQueue.map { $0.url }) {
                                repoManager.addRepo(url: URLFunction.clean(addRepoText)) {
                                    packageManager.refreshRepos()
                                    showingImport = false
                                }
                            }
                        }) {
                            LongButton(
                                text: pasteboardOption ? "Import L" : "Add L",
                                foreground: (addRepoText == "" && !pasteboardOption) ? Color(.tertiaryLabel) : (colorScheme == .dark ? Color(.systemBackground) : .white),
                                background: (addRepoText == "" && !pasteboardOption) ? Color(.quaternarySystemFill) : Color.accentColor,
                                compact: false
                            )
                        }
                        .buttonStyle(DefaultButtonStyle())
                        .disabled(packageManager.working || repoManager.working || (addRepoText == "" && !pasteboardOption))
                        
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, UIConstants.margin)
                    .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
                }
                ,alignment: .bottom
            )
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
}
