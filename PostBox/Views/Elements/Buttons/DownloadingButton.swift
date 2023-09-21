//
//  DownloadingButton.swift
//  PostBox
//
//  Created by Polarizz on 7/26/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI
import PartialSheet

struct DownloadingButton: View {
        
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @State private var modalNumber = 1
    
    @State private var showLogModal = false
    
    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                partialSheetManager.showPartialSheet {
                    DownloadingView(showLogModal: $showLogModal)
                }
            }
        }) {
            Image(systemName: "arrow.down")
                .font(.system(size: UIConstants.footnote).weight(.medium))
                .frame(width: Types.subhead)
                .foregroundColor(.primary)
                .padding(7)
                .background(Color(.tertiarySystemBackground))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                        .opacity(0.25)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(CardButtonStyle())
        .sheet(isPresented: $showLogModal) {
            VStack(spacing: 0) {
                LogView()
            }
        }
    }
}
