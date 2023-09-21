//
//  BubbleController.swift
//  PostBox
//
//  Created by b0kch01 on 11/11/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

/// Manages the bubble notifications
class BubbleController: ObservableObject {
    
    @Published var bubbles = [BData]()
    
    func show(_ bubble: BData) {
        if !Defaults.bool(forKey: "bubbles-disabled") {
            bubbles.append(bubble)
        }
    }
    
    func show(top: LocalizedStringKey, bottom: LocalizedStringKey) {
        if !Defaults.bool(forKey: "bubbles-disabled") {
            bubbles.append(
                BData(top: top, bottom: bottom, icon: "checkmark.circle.fill", color: Color.accentColor)
            )
        }
    }
}

/// Simple data structure for bubbles
struct BData: Identifiable {
    
    var id = UUID()
    var icon: String?
    var color: Color
    
    var top: LocalizedStringKey
    var bottom: LocalizedStringKey
    
    init(top: LocalizedStringKey, bottom: LocalizedStringKey, icon: String? = nil, color: Color) {
        self.top = top
        self.bottom = bottom
        self.icon = icon
        self.color = color
    }
}

/// Main bubble UI
struct Bubble: View {
    
    @State var show = false
    @State var remove = false
    
    private var data: BData
    
    init(_ bData: BData) {
        self.data = bData
    }
    
    var body: some View {
        if !remove {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 1)) { show = false }
            }) {
                ZStack(alignment: .leading) {
                    if let icon = data.icon {
                        Image(systemName: icon)
                            .font(Font(UIFont.preferredFont(forTextStyle: .title2)))
                            .foregroundColor(data.color)
                    }

                    VStack(alignment: .center, spacing: 1) {
                        Text(data.top)
                            .font(.system(size: Types.footnote))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .lineLimit(1)

                        Text(data.bottom)
                            .font(.system(size: Types.footnote))
                            .fontWeight(.medium)
                            .foregroundColor(Color(.tertiaryLabel))
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 35)
                    .padding(.leading, 10)
                }
                .onAppear {
                    withAnimation(.spring(response: 0.3, dampingFraction: 1)) { show = true }
                    DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 2) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 1)) { show = false }
                    }
                    DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 2.3) {
                        remove = true
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 13)
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 39, style: .continuous))
            .shadow(color: Color.black.opacity(0.3), radius: 50, y: 3)
            .scaleEffect(show ? 1 : 0.001, anchor: .top)
            .opacity(show ? 1 : 0)
            .buttonStyle(CardButtonStyle())
        }
    }
}
                                               
