//
//  ReportOptionCardTextField.swift
//  PostBox
//
//  Created by Polarizz on 6/6/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ReportOptionCardTextField: View {
    
    @Environment(\.colorScheme) var colorScheme

    @State private var reportContent: String = ""
    
    @Binding var toggled: Bool
    
    private var symbol: String
    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey
    private var placeholder: LocalizedStringKey
    
    init(toggled: Binding<Bool>, symbol: String, title: LocalizedStringKey, desc: LocalizedStringKey, placeholder: LocalizedStringKey) {
        self._toggled = toggled
        self.symbol = symbol
        self.title = title
        self.desc = desc
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                Haptics.shared.play(.light)

                withAnimation(
                    Animation.spring(response: 0.2, dampingFraction: 1)
                ) {
                    toggled.toggle()
                }
            }) {
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: symbol)
                        .font(.system(size: Types.title2))
                        .frame(width: 35)
                        .padding(.trailing, 11)
                                
                    VStack(alignment: .leading, spacing: 3) {
                        Text(title)
                            .font(.system(size: Types.callout))
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(desc)
                            .font(.system(size: Types.subheadline))
                            .fontWeight(.regular)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()

                    Image(toggled ? "plus.app.fill" : "app")
                        .font(.system(size: UIConstants.title2))
                        .foregroundColor(toggled ? Color.accentColor : Color(.tertiaryLabel))
                        .padding(5)
                        .contentShape(Rectangle())
                }
                .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            }
            .buttonStyle(DefaultButtonStyle())
            
            if toggled {
                Bar()
                    .padding(.top, 13)
                    .padding(.bottom, 11)
                
                MultilineTextField(placeholder, text: $reportContent)
                    .font(.system(size: Types.body))
                    .padding(.leading, -4)
                    .padding(.bottom, -7)
            }
        }
        .padding(16)
        .background(toggled ? (colorScheme == .dark ? Color(.tertiaryLabel) : Color.secondaryBackground) : Color(.quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .shadow(color: Color.black.opacity(toggled ? (colorScheme == .dark ? 0.09 : 0.03) : 0), radius: 15, y: 10)
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
