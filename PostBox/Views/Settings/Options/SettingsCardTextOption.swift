//
//  SettingsCardTextOption.swift
//  PostBox
//
//  Created by Polarizz on 8/12/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct SettingsCardTextOption: View {
    
    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey?
    private var option: String?
    
    init(_ title: LocalizedStringKey, _ desc: LocalizedStringKey?=nil, _ option: String?=nil) {
        self.title = title
        self.desc = desc
        self.option = option
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
                
            if let desc = desc {
                Text(desc)
                    .font(.system(size: Types.subheadline))
                    .fontWeight(.regular)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 3)
            }
        }
    }
}
