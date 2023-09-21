//
//  DepictionSpacerView.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 7/27/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct DepictionSpacerView: View {
    
    var space: CGFloat
    
    init(data: DepictionObjectView) {
        self.space = data.spacing?.numericalValue ?? 0
    }
    
    init(_ space: CGFloat) {
        self.space = space
    }
    
    var body: some View {
        Spacer().frame(height: space)
    }
}
