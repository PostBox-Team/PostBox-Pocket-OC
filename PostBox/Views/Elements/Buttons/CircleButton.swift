//
//  CircleButton.swift
//  PostBox
//
//  Created by Polarizz on 8/13/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

struct CircleButton: View {
    
    private var symbol: String
    private var custom: Bool
    
    init(symbol: String, custom: Bool) {
        self.symbol = symbol
        self.custom = custom
    }
    
    var body: some View {
        SFSymbol(symbol, custom)
            .font(.system(size: UIConstants.footnote).weight(.medium))
            .frame(width: Types.subhead)
            .foregroundColor(.primary)
            .padding(7)
            .background(Color(.tertiarySystemBackground))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color(.tertiaryLabel), lineWidth: 1)
                    .opacity(0.25)
            )
            .contentShape(Rectangle())
    }
}
