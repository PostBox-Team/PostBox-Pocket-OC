//
//  DepictionHeaderView.swift
//  Tweak Explorer
//
//  Created by b0kch01 on 7/27/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct DepictionHeaderView: View {
    
    var data: DepictionObjectView
    var margins: [CGFloat]
    var title: String
    
    init(data: DepictionObjectView) {
        self.data = data
        self.margins = data.getMargins()
        self.title = data.title ?? ""
    }
    
    private func getFontWeight(_ string: String?) -> Font.Weight {
        switch string {
        case "black":
            return .black
        case "bold":
            return .bold
        case "heavy":
            return .heavy
        case "medium":
            return .medium
        case "semibold":
            return .semibold
        case "thin":
            return .thin
        default:
            return .bold
        }
    }
    
    private var talignment: TextAlignment {
        switch data.alignment {
        case 0:
            return TextAlignment.leading
        case 1:
            return TextAlignment.center
        case 2:
            return TextAlignment.trailing
        default:
            return TextAlignment.leading
        }
    }
    
    var body: some View {
        HStack {
            if data.alignment == 1 || data.alignment == 2 { Spacer() }
                
            Text(title)
                .font(Font(UIFont.preferredFont(forTextStyle: .title2)))
                .fontWeight(getFontWeight(data.fontWeight))
                .multilineTextAlignment(talignment)
            
            if data.alignment == 1 || data.alignment == 0 { Spacer() }
        }
        .padding(.top, margins[0])
        .padding(.leading, margins[1])
        .padding(.bottom, margins[2])
        .padding(.trailing, margins[3])
    }
}
