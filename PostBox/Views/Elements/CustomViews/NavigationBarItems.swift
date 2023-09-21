//
//  NavigationBarItems.swift
//  PostBox
//
//  Created by Polarizz on 7/26/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct NavigationBarItems: View {
    var body: some View {
        HStack(spacing: 13) {
            DownloadingButton()
            
            SettingsButton()
        }
    }
}
