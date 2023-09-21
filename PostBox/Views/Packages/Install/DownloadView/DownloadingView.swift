//
//  DownloadingView.swift
//  PostBox
//
//  Created by Polarizz on 7/26/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI
import PartialSheet

struct DownloadingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var packageManager: PackageManager
    
    @State private var showLog = false
    @State private var task = Task { try await Task.sleep(nanoseconds: 0) }
    
    @State private var allSuccess = false
    
    @Binding var showLogModal: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            SplashHeader("Extractions L")
                .padding(.horizontal, UIConstants.margin)
            
            DownloadList()
                .padding(.bottom, 20)
            
            Button(action: {
                showLogModal = true
            }) {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 0) {
                            Text(allSuccess ? LocalizedStringKey("Files processed L") : LocalizedStringKey("Processing theme files L"))
                                .font(.system(size: Types.callout))
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        
                        Text(LocalizedStringKey("Tap for more information. L"))
                            .font(.system(size: Types.subhead))
                            .fontWeight(.regular)
                            .foregroundColor(.secondary)
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
                .padding(.horizontal, UIConstants.margin)
            }
            .buttonStyle(DefaultButtonStyle())
            
            if allSuccess {
                Button(action: {
                    let doc = FileManager.default
                        .urls(for: .documentDirectory, in: .userDomainMask)[0]
                        .absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                    
                    guard let url = URL(string: doc) else { return }
                    
                    UIApplication.shared.open(url)
                }) {
                    LongButton(
                        text: "Open in Files L",
                        foreground: .white,
                        background: Color.accentColor
                    )
                }
                .padding(.horizontal, UIConstants.margin)
                .padding(.vertical, 20)
            }
        }
        .padding(.bottom, UIConstants.margin)
        .onAppear {
            task = Task {
                while true {
                    DispatchQueue.main.async {
                        let hasProcesses = !packageManager.downloadState.isEmpty
                        let allFinished = packageManager.downloadState
                            .allSatisfy { $1 == .success || $1 == .failed }
                        
                        withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                            allSuccess = hasProcesses && allFinished
                        }
                    }
                    
                    try await Task.sleep(nanoseconds: 1_500_000_000)
                }
            }
        }
        .onDisappear { task.cancel() }
    }
}
