//
//  InstallView.swift
//  PostBox
//
//  Created by Polarizz on 4/19/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import PartialSheet
import SWCompression

enum DownloadState {
    case stopped
    case downloading
    case failed
    case success
}

struct InstallView: View {
    
    @EnvironmentObject var partialManager: PartialSheetManager
    @EnvironmentObject var packageManager: PackageManager
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var package: Package
    
    @State private var downloadProgress: Double = 0
    @State private var iconSize: CGFloat = 29
    
    @Binding var showModal: Bool
    
    @State private var tarPath: URL?
    @State private var selectedTab = 0
    
    @State private var localProgress: Progress?
    @State private var localDownloadState: DownloadState = .stopped
        
    var progress: Progress? {
        packageManager.downloadProgress[package.id]
    }
    
    var downloadState: DownloadState {
        packageManager.downloadState[package.id] ?? .stopped
    }
    
    @ViewBuilder
    var body: some View {
        VStack(spacing: 0) {
            Grabber()
                .padding(.bottom, -7)
            
            installHeader
                .padding(.top, 5)
                .padding(.vertical, 16)
            
            Bar()
            
            VStack(spacing: 0) {
                themeOption
                
                HStack(spacing: 0) {
                    Text(LocalizedStringKey("On iOS 14 or below, use a third-party extractor to access.theme files. On iOS 15 and above, .theme files can be accessed via the Files app. L"))
                    
                    Spacer()
                }
                .font(.system(size: Types.footnote))
                .foregroundColor(.secondary)
                .padding(.top, UIConstants.margin)
                .padding(.horizontal, 3)
            }
            .padding(.vertical, UIConstants.margin)
        }
        .padding(.horizontal, UIConstants.margin)
        .onAppear {
            localDownloadState = downloadState
        }
    }
    
    @ViewBuilder
    private var installHeader: some View {
        LeadingHStack {
            package.iconView
                .frame(width: iconSize, height: iconSize)
                .background(Color(.quaternarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: Package.appCornerRadius(width: iconSize), style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: Package.appCornerRadius(width: iconSize), style: .continuous)
                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                        .opacity(0.3)
                )
                .padding(.trailing, 10)
            
            PackageHeader(package.name)
        }
    }
    
    @ViewBuilder
    private var themeOption: some View {
        VStack(alignment: .center, spacing: 13) {
            Button(action: {
                packageManager.downloadState[package.id] = .downloading
                
                package.loadPrice {
                    packageManager.downloadDeb(package: package) { downloadLink in
                        if let url = URL(string: downloadLink) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }) {
                IconCard(
                    icon: "arrow.down.app.fill",
                    title: "Download .deb file L",
                    custom: true
                )
            }
            .buttonStyle(DefaultButtonStyle())
            .disabled(localDownloadState == .downloading)
            
            if progress == nil {
                Button(action: {
                    packageManager.downloadState[package.id] = .downloading
                    
                    package.loadPrice {
                        packageManager.downloadDeb(package: package) { downloadLink in
                            packageManager.downloadProgress[package.id] = packageManager.fetchExtractDeb(package: package, downloadLink: downloadLink) { success, newPath in
                                tarPath = newPath
                                packageManager.downloadState[package.id] = success ? .success : .failed
                            }
                            
                            Task {
                                while localProgress?.isFinished != true {
                                    DispatchQueue.main.async {
                                        withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                                            if localProgress != progress { localProgress = progress }
                                            downloadProgress = localProgress?.fractionCompleted ?? 0
                                            localDownloadState = downloadState
                                        }
                                    }
                                    try await Task.sleep(nanoseconds: 500_000_000)
                                }
                                
                                DispatchQueue.main.async {
                                    withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                                        downloadProgress = 0.9999999
                                    }
                                }
                                
                                try await Task.sleep(nanoseconds: 100_000_000)
                                
                                DispatchQueue.main.async {
                                    withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                                        downloadProgress = 1
                                    }
                                }
                                
                                repeat {
                                    try await Task.sleep(nanoseconds: 500_000_000)
                                    DispatchQueue.main.async {
                                        withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                                            localDownloadState = downloadState
                                        }
                                    }
                                } while downloadState != .success && downloadState != .failed
                            }
                        }
                    }
                }) {
                    IconCard(
                        icon: "doc.zipper",
                        title: "Extract .deb file L",
                        custom: true
                    )
                }
                .buttonStyle(DefaultButtonStyle())
            } else {
                Button(action: {
                    if progress != nil {
                        showModal = true
                    }
                }) {
                    VStack(spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 0) {
                                    Text(localDownloadState == .success ? LocalizedStringKey("Files processed L") : LocalizedStringKey("Processing theme files L"))
                                        .font(.system(size: Types.callout))
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                }
                                
                                Text(LocalizedStringKey("Tap for more information. L"))
                                    .font(.system(size: Types.subhead))
                                    .fontWeight(.regular)
                                    .foregroundColor(.secondary)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                            
                            PackageProgressView(package: package)
                                .padding(.horizontal, 5)
                        }
                        
                        Bar()
                            .padding(.vertical, 13)
                        
                        ShortLog()
                    }
                    .padding(16)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.09 : 0.03), radius: 20, y: 10)
                    .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                }
                .buttonStyle(DefaultButtonStyle())
                
                if localDownloadState == .success {
                    Button(action: {
                        guard let tarPath else { return }
                        let filesURL = tarPath.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                        guard let url = URL(string: filesURL) else { return }
                        UIApplication.shared.open(url)
                    }) {
                        LongButton(
                            text: "Open in Files L",
                            foreground: .white,
                            background: Color.accentColor
                        )
                    }
                } else if localDownloadState == .failed {
                    LongButton(text: "Failed L", foreground: .primary, background: Color(.quaternarySystemFill))
                }
            }
        }
    }
}
