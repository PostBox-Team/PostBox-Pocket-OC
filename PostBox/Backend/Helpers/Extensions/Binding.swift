//
//  Binding.swift
//  PostBox
//
//  Created by b0kch01 on 12/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

/// Allows a binding view to be inverted by the `!` prefix
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
