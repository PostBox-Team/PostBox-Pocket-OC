//
//  InstallButton.swift
//  PostBox
//
//  Created by Polarizz on 1/27/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct InstallButton: View {
            
    private var symbol: String
    private var foreground: Color
    
    init(_ symbol: String, _ foreground: Color) {
        self.symbol = symbol
        self.foreground = foreground
    }
    
    var body: some View {
        Image(symbol)
            .font(.system(size: Types.title2))
            .foregroundColor(foreground)
            .padding(.vertical, 5)
            .contentShape(Rectangle())
    }
}
