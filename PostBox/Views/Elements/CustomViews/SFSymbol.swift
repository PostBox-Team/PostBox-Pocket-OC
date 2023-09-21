//
//  SFSymbol.swift
//  PostBox
//
//  Created by Polarizz on 6/24/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SFSymbol: View {
    
    private var symbol: String
    private var custom: Bool
    
    init(_ symbol: String, _ custom: Bool) {
        self.symbol = symbol
        self.custom = custom
    }
    
    var body: some View {
        Group {
            if custom {
                Image(symbol)
            } else {
                Image(systemName: symbol)
            }
        }
    }
}
