//
//  ReviewCard.swift
//  PostBox
//
//  Created by Polarizz on 2/17/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ReviewCard: View {
        
    /// `0` = empty; `1` = half; `2` = full
    private let rating: [Int]
    private let author: String
    private let content: String
    private let time: Date
    
    init(content: String, author: String, rating: Double, time: Date) {
        self.content = content
        self.author = author
        
        var allRatings = Array(repeating: 0, count: 5)
        for i in (0..<min(5, Int(rating))) { allRatings[i] = 2 }
        
        if rating != Double(Int(rating)) {
            allRatings[Int(rating)] = 1
        }
        
        self.rating = allRatings
        self.time = time
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(author)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text(" • \(time.generalPrecision())")
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .font(.system(size: Types.callout))
            .padding(.bottom, 5)
            
            Text(content)
                .font(.system(size: Types.callout))
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(alignment: .center, spacing: 3) {
                ForEach(rating, id: \.self) { star in
                    if star == 0 {
                        Image("star")
                            .foregroundColor(Color(.tertiaryLabel))
                    } else if star == 1 {
                        Image("star.leadinghalf.fill")
                            .foregroundColor(Color.accentColor)
                    } else {
                        Image("star.fill")
                            .foregroundColor(Color.accentColor)
                    }
                }
                .font(.system(size: Types.subheadline))
                .foregroundColor(Color.accentColor)
            }
            .padding(.top, 10)
        }
        .padding(16)
        .background(Color(.quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
