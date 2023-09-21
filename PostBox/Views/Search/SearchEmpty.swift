//
//  SearchEmpty.swift
//  PostBox
//
//  Created by Polarizz on 3/19/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SearchEmpty: View {
    
    let preferredLanguage = NSLocale.preferredLanguages[0]
    
    private var searchInput: String?
    
    init(searchInput: String?=nil) {
        self.searchInput = searchInput
    }
    
    var body: some View {
        ScrollView {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(LocalizedStringKey("No Results L"))
                        .font(.system(size: Types.callout))
                        .fontWeight(.medium)

                    Group {
                        if let searchInput = searchInput {
                            if preferredLanguage == "zh-Hans" {
                                Text("与")
                                + Text("\"")
                                + Text(searchInput)
                                + Text("\"")
                                + Text("相关")
                            } else if preferredLanguage == "zh-Hant" {
                                Text("與")
                                + Text("\"")
                                + Text(searchInput)
                                + Text("\"")
                                + Text("相關")
                            } else {
                                Text("for ")
                                + Text("\"")
                                + Text(searchInput)
                                + Text("\"")
                            }
                        } else {
                            Text(LocalizedStringKey("Keep typing for more search results. L"))
                        }
                    }
                    .font(.system(size: Types.subheadline).weight(.regular))
                    .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: Types.callout).weight(.medium))
                    .foregroundColor(Color(.tertiaryLabel))
                    .padding(.leading, 10)
                    .padding(.trailing, 3)
            }
            .padding(16)
            .foregroundColor(.secondary)
            .background(Color(.quaternarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .padding(UIConstants.margin)

            Spacer()
        }
        .background(
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
        )
    }
}
