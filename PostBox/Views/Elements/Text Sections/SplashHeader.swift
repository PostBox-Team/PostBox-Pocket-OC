//
//  SplashHeader.swift
//  PostBox
//
//  Created by Polarizz on 3/2/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SplashHeader: View {
    
    private var title: LocalizedStringKey
    
    init(_ title: LocalizedStringKey) {
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Grabber()
                .padding(.bottom, -7)
            
            LeadingHStack {
                Text(title)
                    .font(.system(size: Types.title3))
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 16)
            
            Bar()
        }
    }
}

struct PackageHeader: View {
    
    private var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        LeadingHStack {
            Text(title)
                .font(Font(UIFont.preferredFont(forTextStyle: .title3)))
                .fontWeight(.semibold)
        }
        .padding(.vertical, 1)
    }
}
