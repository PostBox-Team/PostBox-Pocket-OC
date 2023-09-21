//
//  ButtonStyles.swift
//  PostBox
//
//  Created by Polarizz on 11/9/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? -0.039 : 0)
            .animation(.spring(response: 0.1, dampingFraction: 1), value: configuration.isPressed)
    }
}

struct ListButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(configuration.isPressed ? Color(.tertiaryLabel).opacity(0.2) : .clear)
            )
    }
}
