//
//  PackageContentCard.swift
//  PostBox
//
//  Created by Polarizz on 11/22/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import BetterSafariView
import URLImage

/// Main content of depictions
struct PackageContentCard: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var package: Package
    
    @EnvironmentObject var repoManager: RepoManager
    @EnvironmentObject var packageManager: PackageManager
    
    @State var inWishlist: Bool
    
    @Binding var tintColor: Color
        
    var inModal: Bool
    
    init(package: Package, color: Binding<Color>, inModal: Bool?=false) {
        self._inWishlist = State(initialValue: package.inWishList)
        self.package = package
        self._tintColor = color
        self.inModal = inModal!
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if PackageManager.packages[package.id] == nil && PackageManager.cachedPackages[package.id] == nil {
                Button(action: {
                    if let newPackage = PackageManager.packages[package.id] {
                        package.merge(with: newPackage) {
                            inWishlist = package.inWishList
                            package.loadSileoDepictions { color in
                                tintColor = color
                            }
                        }
                    } else {
                        repoManager.addRepo(url: package.repoURL) {
                            packageManager.refreshRepo(for: package.repoURL) {
                                if let newPackage = $0[package.id] {
                                    package.merge(with: newPackage) {
                                        inWishlist = package.inWishList
                                        package.loadSileoDepictions { color in
                                            tintColor = color
                                        }
                                    }
                                }
                            }
                        }
                    }
                }) {
                    WarningCard(
                        link: package.repoURL,
                        text: " in order to view package depiction.",
                        symbol: "plus"
                    )
                    .padding(.horizontal, UIConstants.margin)
                }
                .buttonStyle(DefaultButtonStyle())
            } else {
                if package.sileoDepictionsLoaded {
                    if package.sileoDepiction.class == "DepictionStackView" {
                        DepictionStackView(
                            depiction: package.sileoDepiction,
                            inModal: inModal
                        )
                    } else {
                        DepictionTabView(
                            depiction: package.sileoDepiction,
                            inModal: inModal
                        )
                    }
                } else {
                    VStack(alignment: .leading, spacing: UIConstants.margin) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(package.description)
                                .font(.system(size: Types.callout))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Bar()
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Details")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            DepictionTableTextView(title: "Section", text: package.section)
                            DepictionTableTextView(title: "Version", text: package.version)
                            DepictionTableTextView(title: "Size", text: package.sizeMB)
                        }
                        
                        Bar()

                        if URLFunction.valid(package.depiction) {
                            DepictionTableButtonView(
                                data: DepictionObjectView(title: "View Depiction", action: package.depiction),
                                inModal: inModal
                            )
                        }
                    }
                    .padding(.bottom, UIConstants.margin)
                    .padding(.horizontal, UIConstants.margin)
                }
            }
                                    
            Text(package.identifier)
                .font(.system(size: Types.caption))
                .foregroundColor(.secondary)
                .padding(.top, 20)
                .padding(.bottom, 40)
        }
        .onAppear {
            // Update Package Price
            package.merge(with: PackageManager.packages[package.id] ?? package)
            if let newPrice = PackageManager.prices[package.id] {
                package.priceNum = newPrice
            }

            // Load sileodepictions
            package.loadSileoDepictions { color in
                tintColor = color
            }
        }
    }
}
