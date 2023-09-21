//
//  SceneManager.swift
//  PostBox
//
//  Created by b0kch01 on 4/28/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

public enum NavigateType: String {
    case package
    case repo
}

/// `SceneManager` for the iOS 13 devices! (URL schemes are weird in SwiftUI < iOS 14)
class SceneManager: ObservableObject {
    
    @Published var present     = false
    @Published var action      = ""

    /// Custom HomeView Navigation
    @Published var navigateType: NavigateType?
    @Published var destPackage = Package()
    @Published var destRepo    = Repo()

    var root: String {
        return String(action.split(separator: "/", maxSplits: 1)[0, default: ""])
    }
    
    var content: String {
        return String(action.split(separator: "/", maxSplits: 1)[1, default: ""])
    }
}
