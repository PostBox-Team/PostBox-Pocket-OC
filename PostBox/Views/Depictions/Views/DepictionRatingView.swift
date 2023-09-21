//
//  DepictionRatingView.swift
//  PostBox
//
//  Created by b0kch01 on 2/19/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct DepictionRatingView: View {
    
    private var ratings: [Int]
    private var value: Double
    
    init(data: DepictionObjectView) {
        
        self.value = data.rating ?? 0
        let rating = data.rating ?? 0
        
        var allRatings = Array(repeating: 0, count: 5)
        for i in (0..<min(5, Int(rating))) { allRatings[i] = 2 }
        
        if rating != Double(Int(rating)) {
            allRatings[Int(rating)] = 1
        }
        
        self.ratings = allRatings
    }
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(ratings.indices, id: \.self) { i in
                switch(ratings[i]) {
                case 0: Image("star")
                case 1: Image("star.leadinghalf.fill")
                default: Image("star.fill")
                }
            }
            
            Spacer()
            
            Text(value == 0 ? "N/A" : String(value))
                .font(.system(size: Types.callout))
                .fontWeight(.regular)
                .foregroundColor(.secondary)
        }
        .font(.system(size: Types.body))
    }
}
