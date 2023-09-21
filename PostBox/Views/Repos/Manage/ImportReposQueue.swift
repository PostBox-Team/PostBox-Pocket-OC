//
//  ManageReposQueue.swift
//  PostBox
//
//  Created by Polarizz on 2/5/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ImportReposQueue: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var repoManager: RepoManager
    
    @Binding var sources: [Repo]
    
    @State private var pressed = false
        
    private func removeRow(at offsets: IndexSet) {
        sources.remove(atOffsets: offsets)
    }
    
    private let preferredLanguage = NSLocale.preferredLanguages[0]
    
    var body: some View {
        VStack(spacing: 7) {
            Group {
                if preferredLanguage == "zh-hans" {
                    SectionHeaderNoLocalization("队列中有\(sources.count)个软体源")
                }  else if preferredLanguage == "zh-hant" {
                    SectionHeaderNoLocalization("隊列中有\(sources.count)个軟體源")
                } else {
                    SectionHeaderNoLocalization("\(sources.count) repos in queue")
                }
            }
            .padding(.horizontal, UIConstants.margin)
            
            VStack(spacing: 0) {
                ForEach(sources) { repo in
                    NavigationLink(destination: BrowseRepo(repo)) {
                        HStack(alignment: .center, spacing: 0) {
                            repo.iconView
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
                                        sources = sources.filter { repo.url != $0.url }
                                    }
                                }
                            }) {
                                Image("xmark.app.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: Types.title2))
                            }
                            .buttonStyle(DefaultButtonStyle())
                            .padding(.trailing, 5)
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
        }
    }
}
