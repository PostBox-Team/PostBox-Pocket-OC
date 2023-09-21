//
//  PackageView.swift
//  PostBox
//
//  Created by b0kch01 on 11/11/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import BetterSafariView
import URLImage
import PartialSheet

/// Wraps ContentCard (contains everything on the outside of content)
struct PackageView: View {

    @EnvironmentObject var partialSheetManager: PartialSheetManager

    // Static contants
    private let APP_RADIUS: CGFloat = 90
    
    let preferredLanguage = NSLocale.preferredLanguages[0]

    @EnvironmentObject private var repoManager: RepoManager
    @EnvironmentObject private var packageManager: PackageManager
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var tintColor = Color.primary
    @State private var inWishlist = false
    @State private var showReviewSplash = false
    @State private var popup = false
    @State private var pop = false
    @State private var counter: Int = 0
    @State private var showModal = false
    
    @ObservedObject var package: Package
        
    private var inModal: Bool
    
    private var title2: CGFloat {
        return Types.title2
    }
    
    private var footnote: CGFloat {
        return UIFont.preferredFont(forTextStyle: .footnote).pointSize
    }
    
    init(_ package: Package, inModal: Bool?=false) {
        self.package = package
        self.inModal = inModal!
    }

    var meanScore: String {
        let mean: Double = package.reviews.compactMap { $0.rating.doubleGuess }.reduce(0, +)
        let total: Double = Double(package.reviews.count)
        return String(format: "%.1f", mean / total)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                packageHeader
                    .padding(.horizontal, UIConstants.margin)

                Bar()
                    .padding(UIConstants.margin)
                
                VStack(alignment: .leading, spacing: 0) {
                    PackageContentCard(package: package, color: $tintColor, inModal: inModal)
                }
            }
            .padding(.vertical, UIConstants.margin)
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: NavigationBarItems())
        .accentColor(Color.primary)
        .onAppear {
            inWishlist = package.inWishList
            package.loadReviews()
        }
    }
    
    @ViewBuilder
    private var packageHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            package.iconView
                .frame(width: APP_RADIUS, height: APP_RADIUS)
                .clipShape(RoundedRectangle(cornerRadius: Package.appCornerRadius(width: APP_RADIUS), style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: Package.appCornerRadius(width: APP_RADIUS), style: .continuous)
                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                        .opacity(0.3)
                )
                .padding(.bottom, 16)
                            
            Text(package.name)
                .font(.system(size: Types.title2+2))
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            if let contact = (package.author.name == "Unknown" ? package.maintainer : package.author) {
                Button(action: {
                    if let emailLink = URLFunction.email(contact.email) {
                        UIApplication.shared.open(emailLink)
                    }
                }) {
                    Text(contact.name)
                        .font(.system(size: Types.body))
                        .foregroundColor(.primary)
                }
                .buttonStyle(NoButtonStyle())
                .padding(.top, 7)
            }
            
            HStack(spacing: 5) {
                Image(systemName: "tray")
                    .font(.system(size: Types.subheadline).weight(.medium))
                
                Text(package.repoURLNoProtocol)
                    .font(.system(size: Types.callout))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundColor(.secondary)
            .padding(.top, 7)

            VStack(spacing: 13) {
                packageOptions
            }
            .padding(.top, UIConstants.margin)
        }
    }
    
    private var packageOptions: some View {
        HStack(spacing: 13) {
            Button(action: {
                showReviewSplash = true
            }) {
                reviewButton
            }
            .buttonStyle(DefaultButtonStyle())
            .sheet(isPresented: $showReviewSplash) {
                ReviewView(showReviewSplash: $showReviewSplash, package)
            }
            
            Button(action: {
                Haptics.shared.play(.light)
                
                inWishlist = package.toggleWishlist()
            }) {
                Image(systemName: inWishlist ? "gift.fill" : "gift")
                    .font(.system(size: Types.title2))
                    .frame(height: Types.title2)
                    .foregroundColor(inWishlist ? Color(.systemBackground) : .primary)
                    .padding(16)
                    .background(inWishlist ? Color.accentColor : Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    .contentShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            }
            .buttonStyle(DefaultButtonStyle())
            
            VerticalBar()
                .frame(height: title2 + 32)
                .padding(.horizontal, 3)
            
            Button(action: {
                DispatchQueue.main.async {
                    partialSheetManager.showPartialSheet {
                        InstallView(package: package, showModal: $showModal)
                    }
                }
            }) {
                CenterHStack {
                    Text(package.priceStr)
                }
                .font(.system(size: Types.body).weight(.medium))
                .frame(height: Types.title2)
                .foregroundColor(Color(.systemBackground))
                .padding(.vertical, 16)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            }
            .buttonStyle(DefaultButtonStyle())
            .background(EmptyView())
            .sheet(isPresented: $showModal) {
                LogView()
            }
        }
    }
    
    private var reviewButton: some View {
        Group {
            if package.meanScore == "nan" {
                Image(systemName: "text.bubble")
                    .font(.system(size: Types.title2))
                    .frame(height: Types.title2)
            } else {
                Text(package.meanScore)
                    .font(.system(size: Types.title2, design: .rounded).weight(.semibold))
                    .frame(height: Types.title2)
            }
        }
        .foregroundColor(.primary)
        .padding(16)
        .background(Color(.quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
    }
}
