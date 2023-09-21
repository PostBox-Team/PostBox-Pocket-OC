//
//  Wishlist View.swift
//  PostBox
//
//  Created by b0kch01 on 12/16/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsWishlistView: View {
    
    @State private var editMode: EditMode = EditMode.inactive
    @State private var wishlist: [Package]
    
    @State private var searchText: String = ""
            
    init() {
        self._wishlist = State(initialValue: SettingsWishlistView.getWishList())
    }
    
    static func getWishList() -> [Package] {
        let wishlistStr = Defaults.stringArray(forKey: "wishlist") ?? []
        
        return wishlistStr.map {
            /// 0: id, 1: name, 2: desc
            let parts = $0.components(separatedBy: "||")
            
            if let cachedPackage = PackageManager.packages[parts.first ?? "none"] {
                return cachedPackage
            }
            
            let id = parts.first?.groups(for: "(.*?)http[s]?:\\/\\/").first?.first
            let name = parts.count > 1 ? parts[1] : "Unknown Package"
            let desc = parts.count > 2 ? parts[2] : "A package saved to wishlist"
            let repo = parts.count > 3 ? parts[3] : nil
            
            return Package(id: id, name: name, description: desc, repoURL: repo)
        }
    }
    
    private func syncToDefaults() {
        let stringWishlist = wishlist.map {
            [$0.id, $0.name, $0.description, $0.repoURL].joined(separator: "||")
        }
        
        Defaults.set(stringWishlist, forKey: "wishlist")
        wishlist = SettingsWishlistView.getWishList()
    }
    
    private func onDelete(offsets: IndexSet) {
        wishlist.remove(atOffsets: offsets)
        syncToDefaults()
    }

    private func onMove(source: IndexSet, destination: Int) {
        wishlist.move(fromOffsets: source, toOffset: destination)
        syncToDefaults()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if wishlist.count == 0 {
                    NullCard(
                        symbol: "gift",
                        title: "Empty Wish List L",
                        desc: "Save packages using the Wish button in depictions. L",
                        custom: false
                    )
                    .padding(UIConstants.margin)
                } else {
                    VStack(spacing: 7) {
                        SectionHeader("Wished")
                            .padding(.horizontal, UIConstants.margin)

                        VStack(spacing: 0) {
                            ForEach(wishlist.filter({
                                searchText == "" ||
                                $0.name.localizedStandardContains(searchText) ||
                                $0.description.localizedStandardContains(searchText)
                            })) { package in
                                NavigationLink(destination: PackageView(package)) {
                                    PackageCard(package: package)
                                }
                                .buttonStyle(NoButtonStyle())
                                .contextMenu(ContextMenu(menuItems: {
                                    package.contextMenu
                                }))
                                
                                Bar()
                                    .padding(.leading, 61)
                                    .padding(.horizontal, UIConstants.margin)
                            }
                            .onDelete(perform: onDelete)
                            .onMove(perform: onMove)
                            .onAppear {
                                wishlist = SettingsWishlistView.getWishList()
                            }
                        }
                    }
                    .padding(.vertical, UIConstants.margin)
                }
                
                Spacer()
            }
        }
        .navigationBarTitle(LocalizedStringKey("Wish List L"), displayMode: .inline)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
}
