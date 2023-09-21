//
//  StatusBarBackground.swift
//  PostBox
//
//  Created by Paul Wong on 11/8/20.
//  Copyright © 2020 icycabbage. All rights reserved.
//

import SwiftUI

struct StatusBarBackground: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Color(.systemBackground)
                    .frame(height: geo.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
                Spacer()
            }
        }
    }
}
