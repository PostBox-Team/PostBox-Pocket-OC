//
//  DepictionSubheaderView.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 7/25/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct DepictionSubheaderView: View {
    
    var data: DepictionObjectView
    
    var body: some View {
        Text(data.title ?? "")
            .font(.headline)
            .multilineTextAlignment(.leading)
    }
}
