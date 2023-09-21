//
//  View.swift
//  PostBox
//
//  Created by b0kch01 on 11/17/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

struct SettingsSectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color(.quaternarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
    }
}

extension HStack {
    func settingsSectionStyle() -> some View {
        self.modifier(SettingsSectionModifier())
    }
}

extension VStack {
    func settingsSectionStyle() -> some View {
        self.modifier(SettingsSectionModifier())
    }
}

extension View {
    func `check`<Content: View>(content: (Self) -> Content) -> some View {
        return AnyView(content(self))
    }
    
    /// https://forums.swift.org/t/conditionally-apply-modifier-in-swiftui/32815/3
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
         if conditional {
             return AnyView(content(self))
         } else {
             return AnyView(self)
         }
     }

    /// Apply modifier if device is on iOS 14
    func if15<Content: View>(content: (Self) -> Content) -> some View {
        return AnyView(content(self))
    }
    
    /// Apply modifier if device is on iOS 14
    func if14<Content: View>(content: (Self) -> Content) -> some View {
        if #available(iOS 14, *) {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
    
    /// Apply modifier if device is on iOS 13 (not iOS 14)
    func if13<Content: View>(content: (Self) -> Content) -> some View {
        if #available(iOS 14, *) {
            return AnyView(self)
        } else {
            return AnyView(content(self))
        }
    }
    
    /// `.sheet` but adds an accent color modifier
    func modal<Content: View>(_ isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        AnyView(
            self.sheet(isPresented: isPresented) {
                content().accentColor(uiConstants.dynamicColor)
            }
        )
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/// https://stackoverflow.com/a/65784549/14853522
/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
