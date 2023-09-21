//
//  PackageWishlist.swift
//  PostBox
//
//  Created by b0kch01 on 7/24/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

extension Package {
    // MARK: - Wishlist Functionality
    
    /// Packs package data into a String for wishlist
    private var wishlistString: String {
        [id, name, description, repoURL].joined(separator: "||")
    }
    
    /// - Returns `true` if package is in wishlist
    var inWishList: Bool {
        (Defaults.stringArray(forKey: "wishlist") ?? [])
            .contains(wishlistString)
    }
    /// Add current package to wishlist; returns `true`
    func addToWishlist() -> Bool {
        var currentWishlist = Defaults.stringArray(forKey: "wishlist") ?? []
        currentWishlist.append(wishlistString)
        
        Defaults.set(currentWishlist, forKey: "wishlist")
        
        return true
    }
    /// Remove current package to wishlist
    /// - Returns `false`
    func removeFromWishlist() -> Bool {
        let currentWishlist = Defaults.stringArray(forKey: "wishlist") ?? []
        let newWishlist = currentWishlist.filter({ !$0.contains(id) })
        
        Defaults.set(newWishlist, forKey: "wishlist")
        
        return false
    }
    
    /// Toggle package existence in wishlist
    /// - Returns `true` if added and `false` if removed
    func toggleWishlist() -> Bool {
        return inWishList ? removeFromWishlist() : addToWishlist()
    }
}
