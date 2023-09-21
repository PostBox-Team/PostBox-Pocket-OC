//
//  DepictionImageView.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 7/27/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import URLImage

struct DepictionImageView: View {

    var url: URL
    var width: CGFloat
    var height: CGFloat
    var cRadius: CGFloat
    var alignment: Int
    
    init(data: DepictionObjectView) {
        self.url = URLFunction.url(data.URL)
        self.width = CGFloat(data.width ?? 0)
        self.height = CGFloat(data.height ?? 0)
        self.cRadius = CGFloat(data.cornerRadius ?? 0)
        self.alignment = data.alignment ?? 0
    }
    
    init(url: String, width: CGFloat?=0, height: CGFloat?=0, cRadius: CGFloat?=0, alignment: Int?=0) {
        self.url = URL(string: url)!
        self.width = width!
        self.height = height!
        self.cRadius = cRadius!
        self.alignment = alignment!
    }
    
    var body: some View {
        HStack {
            if alignment == 1 || alignment == 2 { Spacer() }

            URLImage(
                url: url,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: cRadius, style: .continuous))
                        .frame(maxWidth: min(width, UIScreen.main.bounds.maxX - 80), maxHeight: height)
            })
            
            if alignment == 1 || alignment == 0 { Spacer() }
        }
    }
}
