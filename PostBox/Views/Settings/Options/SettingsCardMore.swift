//
//  SettingsCardMore.swift
//  PostBox
//
//  Created by Polarizz on 6/19/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsCardMore: View {
    
    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey?
    
    init(title: LocalizedStringKey, desc: LocalizedStringKey?=nil) {
        self.title = title
        self.desc = desc
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let desc = desc {
                    Text(desc)
                        .font(.system(size: Types.subheadline))
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                        .padding(.top, 3)
                }
            }

            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: UIConstants.callout).weight(.medium))
                .foregroundColor(Color(.tertiaryLabel))
                .padding(.trailing, 3)
        }
        .contentShape(Rectangle())
    }
}
