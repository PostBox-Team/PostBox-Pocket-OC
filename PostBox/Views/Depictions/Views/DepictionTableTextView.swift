//
//  DepictionTableTextView.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 7/27/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct DepictionTableTextView: View {
    
    @State var full = false
    
    var title: String
    var text: String
    
    init(data: DepictionObjectView) {
        self.title = data.title ?? ""
        self.text = data.text ?? ""
    }
    
    init(title: String, text: String) {
        self.title = title == "" ? "---" : title
        self.text = text == "" ? "---" : text
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { full.toggle() }
        }) {
            HStack {
                if !full {
                    Text(title)
                        .font(.system(size: Types.callout))
                        .foregroundColor(Color(.tertiaryLabel))
                        .lineLimit(1)
                        .padding(.trailing, 50)
                }
                
                Spacer()
                
                Text(text)
                    .font(.system(size: Types.callout))
                    .fontWeight(.regular)
                    .foregroundColor(.accentColor)
                    .lineLimit(1)
                
                if full {
                    Spacer()
                }
            }
            .padding(.vertical, 5)
        }
    }
}
