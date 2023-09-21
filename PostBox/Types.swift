//
//  Types.swift
//  PostBox
//
//  Created by Polarizz on 8/5/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

class Types: ObservableObject {
    
    static var largeTitle: CGFloat {
        return UIFont.preferredFont(forTextStyle: .largeTitle).pointSize as CGFloat
    }
    
    static var title: CGFloat {
        return UIFont.preferredFont(forTextStyle: .title1).pointSize as CGFloat
    }
    
    static var title2: CGFloat {
        return UIFont.preferredFont(forTextStyle: .title2).pointSize as CGFloat
    }
    
    static var title3: CGFloat {
        return UIFont.preferredFont(forTextStyle: .title3).pointSize as CGFloat
    }
    
    static var body: CGFloat {
        return UIFont.preferredFont(forTextStyle: .body).pointSize as CGFloat
    }
    
    static var callout: CGFloat {
        return UIFont.preferredFont(forTextStyle: .callout).pointSize as CGFloat
    }
    
    static var subheadline: CGFloat {
        return UIFont.preferredFont(forTextStyle: .subheadline).pointSize as CGFloat
    }
    
    static var subhead: CGFloat {
        return UIFont.preferredFont(forTextStyle: .footnote).pointSize + 1 as CGFloat
    }
    
    static var footnote: CGFloat {
        return UIFont.preferredFont(forTextStyle: .footnote).pointSize as CGFloat
    }
    
    static var caption: CGFloat {
        return UIFont.preferredFont(forTextStyle: .caption1).pointSize as CGFloat
    }
}
