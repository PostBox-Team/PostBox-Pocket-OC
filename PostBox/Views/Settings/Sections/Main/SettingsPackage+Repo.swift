//
//  SettingsPackage+Repo.swift
//  PostBox
//
//  Created by Polarizz on 5/15/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsPackageRepo: View {
    var body: some View {
        VStack(spacing: 16) {
            SettingsOption(
                symbol: "gift.fill",
                title: "Wish List L",
                desc: "Save your favorite packages L",
                custom: false
            ) {
                SettingsWishlistView()
            }
            
            Bar()
                .padding(.leading, Types.title3 + 31)
            
            SettingsOption(
                symbol: "cart.fill",
                title: "Stores L",
                desc: "Manage signed in repos L",
                custom: false
            ) {
                SettingsStores()
            }
        }
        .settingsSectionStyle()
    }
}
