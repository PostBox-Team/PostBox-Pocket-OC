//
//  RepoLoadingView.swift
//  PostBox
//
//  Created by Polarizz on 8/6/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct RepoLoadingView: View {
    var body: some View {
        VStack(spacing: 0) {
            SplashHeader("Refresh Progress L")
                .padding(.horizontal, UIConstants.margin)
            
            ScrollView {
                ManageReposModalQueue()
                    .padding(.bottom, UIConstants.margin*3)
            }
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
}
