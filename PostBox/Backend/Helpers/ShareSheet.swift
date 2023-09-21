//
//  ShareSheet.swift
//  PostBox
//
//  Created by b0kch01 on 12/21/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

/// ShareScreen
struct ShareSheet {
    static func share(_ items: [Any]) {
        let activitySheet = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        UIApplication.shared.windows[1, default: UIApplication.shared.windows[0]]
            .rootViewController?.present(activitySheet, animated: true)
    }
    
    static func share(_ item: Any?) {
        let shareItems = [item ?? "Nothing was shared"]
        share(shareItems)
    }
}
