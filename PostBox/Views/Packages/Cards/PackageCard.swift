//
//  PackageCard.swift
//  PostBox
//
//  Created by Polarizz on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import PartialSheet

struct PackageCard: View {
        
    @EnvironmentObject var partialSheetManager: PartialSheetManager

    @ObservedObject var package: Package
        
    let packageCardType: PackageCardType
    let version: NewPackageVersion?
    
    let preferredLanguage = NSLocale.preferredLanguages[0]
    
    @State private var showModal = false

    enum PackageCardType {
        case packageCard
        case packageListCard
        case change
    }
        
    init(package: Package, type: PackageCardType?=nil, version: NewPackageVersion?=nil) {
        self.packageCardType = type ?? .packageCard
        self.package = package
        self.version = version
    }
    
    var descriptionText_en: String {
        if packageCardType == .change, let version {
            if version.from > version.to {
                return "Downgraded from \(version.from) → \(version.to)"
            }
            
            if version.from < version.to {
                return "Updated from \(version.from) → \(version.to)"
            }
            
            return "Added as \(version.to)"
            
        } else {
            return package.description
        }
    }
    
    var descriptionText_zhHans: String {
        if packageCardType == .change, let version {
            if version.from > version.to {
                return "从 \(version.from) 降级到 \(version.to)"
            }
            
            if version.from < version.to {
                return "从 \(version.from) 更新到 \(version.to)"
            }
            
            return "添加为 \(version.to)"
            
        } else {
            return package.description
        }
    }
    
    var descriptionText_zhHant: String {
        if packageCardType == .change, let version {
            if version.from > version.to {
                return "從 \(version.from) 降級到 \(version.to)"
            }
            
            if version.from < version.to {
                return "從 \(version.from) 更新到 \(version.to)"
            }
            
            return "添加為 \(version.to)"
            
        } else {
            return package.description
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            package.iconView
                .frame(width: 45, height: 45)
                .background(Color(.quaternarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: Package.appCornerRadius(width: 45), style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: Package.appCornerRadius(width: 45), style: .continuous)
                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                        .opacity(0.3)
                )
                .padding(.trailing, 16)
                        
            VStack(alignment: .leading, spacing: 3) {
                Text(package.name)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                if preferredLanguage == "zh-Hans" {
                    updateInfo_zhHans
                } else if preferredLanguage == "zh-Hant" {
                    updateInfo_zhHant
                } else {
                    updateInfo_en
                }
            }
            .offset(y: packageCardType == .change ? 2 : 0)
            .fixedSize(horizontal: false, vertical: true)

            Spacer()
            
            Button(action: {
                DispatchQueue.main.async {
                    partialSheetManager.showPartialSheet {
                        InstallView(package: package, showModal: $showModal)
                    }
                }
            }) {
                InstallButton(
                    "arrow.up.forward.app.fill",
                    Color(.tertiaryLabel)
                )
                .padding(20)
                .contentShape(Rectangle())
            }
            .buttonStyle(DefaultButtonStyle())
            .padding(-20)
            .padding(.trailing, 5)
        }
        .padding(.vertical, packageCardType != .packageListCard ? 11 : 6)
        .padding(.horizontal, packageCardType != .packageListCard ? UIConstants.margin/2 : 0)
        .background(packageCardType != .packageListCard ? Color.primaryBackground : Color(.clear))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .padding(.horizontal, packageCardType != .packageListCard ? UIConstants.margin/2 : 0)
        .onAppear {
            package.merge(with: PackageManager.packages[package.id] ?? package)
            if let newPrice = PackageManager.prices[package.id] {
                package.priceNum = newPrice
            }
        }
        .sheet(isPresented: $showModal) {
            LogView()
        }
    }
    
    private var updateInfo_en: some View {
        Group {
            if packageCardType == .change, let version {
                if version.from > version.to {
                    HStack(spacing: 0) {
                        Text("Downgraded from ")
                        
                        Text(version.from)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                        Text(" → ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                } else if version.from < version.to {
                    HStack(spacing: 0) {
                        Text("Updated from ")
                        
                        Text(version.from)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                        Text(" → ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                } else {
                    HStack(spacing: 0) {
                        Text("Added as ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                }
                
            } else {
                Text(descriptionText_en)
            }
        }
        .font(.system(size: Types.subheadline).weight(.regular))
        .foregroundColor(.secondary)
        .lineLimit(1)
    }
    
    private var updateInfo_zhHans: some View {
        Group {
            if packageCardType == .change, let version {
                if version.from > version.to {
                    HStack(spacing: 0) {
                        Text("从 ")
                        
                        Text(version.from)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                        Text(" 降级到 ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                } else if version.from < version.to {
                    HStack(spacing: 0) {
                        Text("从 ")
                        
                        Text(version.from)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                        Text(" 更新到版本 ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                } else {
                    HStack(spacing: 0) {
                        Text("添加为 ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                }
                
            } else {
                Text(descriptionText_zhHans)
            }
        }
        .font(.system(size: Types.subheadline).weight(.regular))
        .foregroundColor(.secondary)
        .lineLimit(1)
    }
    
    private var updateInfo_zhHant: some View {
        Group {
            if packageCardType == .change, let version {
                if version.from > version.to {
                    HStack(spacing: 0) {
                        Text("從 ")
                        
                        Text(version.from)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                        Text(" 降級到版本 ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                } else if version.from < version.to {
                    HStack(spacing: 0) {
                        Text("從")
                        
                        Text(version.from)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                        Text(" 更新到版本 ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                } else {
                    HStack(spacing: 0) {
                        Text("添加為 ")
                        
                        Text(version.to)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 5)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                }
                
            } else {
                Text(descriptionText_zhHant)
            }
        }
        .font(.system(size: Types.subheadline).weight(.regular))
        .foregroundColor(.secondary)
        .lineLimit(1)
    }
}
