//
//  Bar.swift
//  PostBox
//
//  Created by Polarizz on 6/25/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct Bar: View {
    var body: some View {
        Rectangle()
            .fill(Color(.tertiarySystemFill))
            .frame(height: 1)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct VerticalBar: View {
    var body: some View {
        Rectangle()
            .fill(Color(.tertiarySystemFill))
            .frame(width: 1)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
