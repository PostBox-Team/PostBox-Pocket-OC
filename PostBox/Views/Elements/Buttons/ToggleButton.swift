//
//  ToggleButton.swift
//  PostBox
//
//  Created by Polarizz on 11/30/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

/// Button that toggles on and off (used in preferences)
struct ToggleCheckButton: View {
    
    @Binding var isOn: Bool
    
    var disables: Bool
    var toggle: () -> Void
    
    init(isOn: Binding<Bool>, disables: Bool?=false, toggle: @escaping () -> Void) {
        self._isOn = isOn
        self.disables = disables!
        self.toggle = toggle
    }
    
    var body: some View {
        Button(action: toggle) {
            Image("checkmark.app.fill")
                .font(.system(size: UIConstants.title2))
                .foregroundColor(isOn ? Color.accentColor : Color(.tertiaryLabel))
                .scaleEffect(isOn ? 1 : 0.001)
                .background(
                    Image("app")
                        .font(.system(size: UIConstants.title2))
                        .foregroundColor(Color(.tertiaryLabel))
                        .scaleEffect(isOn ? 0.8 : 1)
                )
                .padding(.horizontal, UIScreen.main.bounds.maxX)
                .padding(.trailing, 3)
                .contentShape(Rectangle())
        }
        .disabled(isOn && disables)
        .buttonStyle(DefaultButtonStyle())
        .padding(.horizontal, -UIScreen.main.bounds.maxX)
    }
}
