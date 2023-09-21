//
//  PullToRefreshScrollView.swift
//  PostBox
//
//  Created by b0kch01 on 12/29/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import UIKit

private enum PositionType {
    case fixed, moving
}

private struct Position: Equatable {
    let type: PositionType
    let y: CGFloat
}

private struct PositionPreferenceKey: PreferenceKey {
    
    typealias Value = [Position]
    
    static var defaultValue = [Position]()
    
    static func reduce(value: inout [Position], nextValue: () -> [Position]) {
        value.append(contentsOf: nextValue())
    }
}

private struct PositionIndicator: View {
    let type: PositionType
    
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: PositionPreferenceKey.self, value: [Position(type: type, y: proxy.frame(in: .global).minY)])
        }
    }
}

private let THRESHOLD: CGFloat = 120

private enum RefreshState {
    case waiting, primed, loading
}

struct RefreshableScrollView<Content: View>: View {
    
    private var image: String
    
    let onRefresh: (@escaping () -> Void) -> Void
    let content: Content
    
    @State private var state = RefreshState.waiting
    @State private var pullstate = CGFloat.zero
    @State private var scale: CGFloat = 0
    @State private var opacity: CGFloat = 0
    @State private var rotation: CGFloat = 0

    init(image: String, onRefresh: @escaping (@escaping () -> Void) -> Void, @ViewBuilder content: () -> Content) {
        self.image = image
        self.onRefresh = onRefresh
        self.content = content()
    }
        
    @ViewBuilder
    var body: some View {
        ScrollView {
            content
                .overlay(
                    PositionIndicator(type: .moving)
                        .frame(height: 0)
                    ,
                    alignment: .top
                )
        }
        .overlay(
            Image(systemName: image)
                .font(Font(UIFont.preferredFont(forTextStyle: .title2)))
                .foregroundColor(.primary)
                .rotationEffect(.degrees(rotation))
                .scaleEffect(max(0, min(scale, 1)))
                .opacity(max(0, min(opacity-0.3, 1)))
                .frame(height: 0)
                .padding(.top, 40)
            ,alignment: .top
        )
        .background(PositionIndicator(type: .fixed))
        .onPreferenceChange(PositionPreferenceKey.self) { values in
            DispatchQueue.main.async {
                if state != .loading {
                    let movingY = values.first { $0.type == .moving }?.y ?? 0
                    let fixedY = values.first { $0.type == .fixed }?.y ?? 0
                    let offset = movingY - fixedY
                    scale = offset/THRESHOLD
                    opacity = offset/THRESHOLD
                    rotation = (offset/THRESHOLD)*180
                    
                    self.pullstate = offset
                    
                    if offset > THRESHOLD && state == .waiting {
                        Haptics.shared.play(.light)
                        state = .primed
                    } else if offset < THRESHOLD && state == .primed {
                        withAnimation(.easeOut(duration: 0.39)) {
                            scale = 0
                            rotation = 0
                            opacity = 0
                        }
                        state = .loading
                        onRefresh {
                            self.state = .waiting
                        }
                    }
                }
            }
        }
    }
}
