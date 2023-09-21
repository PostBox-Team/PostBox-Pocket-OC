//
//  Stacks.swift
//  Pocket
//
//  Created by Polarizz on 9/13/22.
//  Copyright © 2022 PostBox Team. All rights reserved.
//

import SwiftUI

/// Uses `LazyVStack` when over iOS 14; `VStack` when less than iOS 14
struct VerticalStack<Content>: View where Content: View {
    
    let content: () -> Content
    let alignment: HorizontalAlignment
    let spacing: CGFloat?
    
    init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.alignment = alignment
        self.spacing = spacing
    }
    
    var body: some View {
        if #available(iOS 14.0, *) {
            LazyVStack(alignment: alignment, spacing: spacing, content: content)
        } else {
            VStack(alignment: alignment, spacing: spacing, content: content)
        }
    }
}

struct CenterStack<Content>: View where Content: View {
    
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                content
                
                Spacer()
            }
        }
    }
}

struct LeadingHStack<Content>: View where Content: View {
    
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 0) {
            content
            
            Spacer()
        }
    }
}

struct CenterHStack<Content>: View where Content: View {
    
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            content
            
            Spacer()
        }
    }
}
