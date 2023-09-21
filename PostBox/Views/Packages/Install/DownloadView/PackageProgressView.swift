//
//  PackageProgressView.swift
//  PostBox
//
//  Created by b0kch01 on 7/27/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct PackageProgressView: View {
    
    @EnvironmentObject var packageManager: PackageManager
    
    @ObservedObject var package: Package
    
    @State private var initiated: Bool = false
    
    @State private var localProgress: Progress?
    @State private var localDownloadState: DownloadState = .stopped
    @State private var downloadProgress: Double = 0
    
    @State private var task = Task { try await Task.sleep(nanoseconds: 0) }
    
    var progress: Progress? {
        packageManager.downloadProgress[package.id]
    }
    
    var downloadState: DownloadState {
        packageManager.downloadState[package.id] ?? .stopped
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            ActivityIndicator()
                .scaleEffect(
                    downloadProgress == 1 && localDownloadState == .downloading ? 1 : 0.001
                )
                .frame(
                    width: Types.subheadline,
                    height: Types.subheadline
                )
            
            Group {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.accentColor)
                    .font(.system(size: Types.title2))
                    .scaleEffect(
                        downloadProgress == 1 && localDownloadState == .success ? 1 : 0.001
                    )
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: Types.title2))
                    .scaleEffect(
                        downloadProgress == 1 && localDownloadState == .failed ? 1 : 0.001
                    )
            }
            
            Group {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(Color(.quaternarySystemFill))
                    .transition(.scale)
                    .scaleEffect(downloadProgress != 1 ? 1 : 0.001)
                
                Circle()
                    .trim(from: 0.0, to: downloadProgress)
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.accentColor)
                    .rotationEffect(Angle(degrees: 270.0))
                    .transition(.scale)
                    .scaleEffect(downloadProgress != 1 ? 1 : 0.001)
            }
            .frame(
                width: Types.title2,
                height: Types.title2
            )
        }
        .onAppear {
            downloadProgress = progress?.fractionCompleted ?? 0
            localDownloadState = downloadState
            
            self.task = Task {
                while progress?.isFinished != true {
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
                        downloadProgress = max(0.9999999, downloadProgress)
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
        .onDisappear { task.cancel() }
    }
}
