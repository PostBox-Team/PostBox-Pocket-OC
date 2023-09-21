//
//  HomeLoadingCard.swift
//  PostBox
//
//  Created by Polarizz on 6/24/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import PartialSheet

struct HomeLoadingCard: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager

    @State private var showRepoModal = false
    
    @Binding var progress: Double
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                showRepoModal = true
            }) {
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(LocalizedStringKey("Loading Recently Updated Packages L"))
                            .font(.system(size: Types.callout))
                            .fontWeight(.medium)
                        
                        Text(LocalizedStringKey("Tap to see loading progress. L"))
                            .font(.system(size: Types.subheadline))
                            .fontWeight(.regular)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    ZStack(alignment: .center) {
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(Color(.quaternarySystemFill))
                            .transition(.scale)
                        
                        Circle()
                            .trim(from: 0.0, to: progress/4)
                            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.accentColor)
                            .rotationEffect(Angle(degrees: 270.0))
                            .transition(.scale)
                    }
                    .frame(
                        width: UIFont.preferredFont(forTextStyle: .body).pointSize,
                        height: UIFont.preferredFont(forTextStyle: .body).pointSize
                    )
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                }
                .padding(16)
                .foregroundColor(.secondary)
                .background(Color(.quaternarySystemFill).opacity(colorScheme == .dark ? 0.5 : 1))
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                .padding(.horizontal, UIConstants.margin)
                .padding(.top, 6)
                .padding(.bottom, 9)
            }
            .buttonStyle(DefaultButtonStyle())
            .sheet(isPresented: $showRepoModal) {
                RepoLoadingView()
            }
            
            ForEach((1...20), id: \.self) { _ in
                RedactedListCard("arrow.up.forward.app.fill")
                
                Bar()
                    .padding(.leading, 61)
                    .padding(.horizontal, UIConstants.margin)
            }
        }
    }
}
