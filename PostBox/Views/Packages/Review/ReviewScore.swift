//
//  ReviewScore.swift
//  PostBox
//
//  Created by Polarizz on 7/7/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ReviewScore: View {
    
    private var score: String
    
    init(_ score: String) {
        self.score = score
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(score)
                .font(.system(size: Types.largeTitle*2, design: .rounded))
                .fontWeight(.semibold)
            
            Text("out of 5")
                .font(.system(size: Types.body))
        }
    }
}
