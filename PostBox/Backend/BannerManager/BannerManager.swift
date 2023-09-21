//
//  BannerManager.swift
//  PostBox
//
//  Created by Nathan Choi on 8/27/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI
import Firebase

final class BannerManager: ObservableObject {

    // New update banner will show if this is    true
    @Published var newUpdate = false
    @Published var newUpdateLink = "postbox.news"
    
    public func checkForNewVersion() {
        Firestore.firestore().collection("alerts").document("latest-version")
            .getDocument(source: .server) { [weak self] snapshot, error in
                if let error {
                    print("❌ Couldn't get latest version:", error)
                    return
                }
                
                guard let data = snapshot?.data() else {
                    print("❌ Couldn't get latest version data (empty)")
                    return
                }
                
                if let latestVersion = data["version"] as? String {
                    let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                    print("🛰 Current version:", currentVersion, "| Latest Version:", latestVersion)
                    
                    withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                        self?.newUpdate = latestVersion > currentVersion
                    }
                }
                
                if let link = data["link"] as? String {
                    print("🛰 New version link:", link)
                    self?.newUpdateLink = link
                }
            }
    }
}
