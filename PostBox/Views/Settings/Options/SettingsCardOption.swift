//
//  SettingsCardOption.swift
//  PostBox
//
//  Created by Polarizz on 6/22/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsCardOption: View {
    
    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey?
    private var symbol: String
    private var color: Color
    
    init(title: LocalizedStringKey, desc: LocalizedStringKey?=nil, symbol: String, color: Color) {
        self.title = title
        self.desc = desc
        self.symbol = symbol
        self.color = color
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(color)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let desc = desc {
                    Text(desc)
                        .font(.system(size: Types.subheadline))
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 3)
                }
            }
            
            Spacer()
            
            Image(symbol)
                .font(.system(size: UIConstants.title2))
                .foregroundColor(color)
                .padding(.trailing, 3)
        }
    }
}
