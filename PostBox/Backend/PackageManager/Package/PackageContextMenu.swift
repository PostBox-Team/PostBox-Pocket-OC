//
//  PackageContextMenu.swift
//  PostBox
//
//  Created by b0kch01 on 7/24/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

extension Package {
    // MARK: - Context Menu
    
    @ViewBuilder var contextMenu: some View {
        
        Divider()
        
        Button(action: { [weak self] in
            UIPasteboard.general.string = self?.repoURL
        }) {
            Image(systemName: "doc.on.clipboard")
            Text("Copy source")
        }
    }
}
