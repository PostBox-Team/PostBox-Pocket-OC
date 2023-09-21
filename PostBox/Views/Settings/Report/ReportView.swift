//
//  ReportView.swift
//  PostBox
//
//  Created by Polarizz on 6/6/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ReportView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var image = UIImage()
    
    @State private var toggledLog = false
    @State private var toggledBugs = false
    @State private var toggledHarmful = false
    @State private var toggledFeedback = false
    
    @State private var imageModal = false

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    Text("Select one or more options")
                        .font(.title.weight(.bold))
                        .multilineTextAlignment(.center)
                        .padding(40)
                    
                    VStack(alignment: .center, spacing: 13) {
                        ReportOptionCard(
                            toggled: $toggledLog,
                            symbol: "terminal.fill",
                            title: "App Log L",
                            desc: "Send App Log for debugging purposes. L"
                        )
                        
                        ReportOptionCardTextField(
                            toggled: $toggledBugs,
                            symbol: "ant.fill",
                            title: "Bugs L",
                            desc: "Report specific issues in PostBox. L",
                            placeholder: "Describe the issue L"
                        )
                        
                        ReportOptionCardTextField(
                            toggled: $toggledFeedback,
                            symbol: "bubble.left.and.bubble.right.fill",
                            title: "Feedback L",
                            desc: "Leave us feedback so PostBox can continue improving. L",
                            placeholder: "Leave us a feedback L"
                        )
                    }
                }
                .padding([.horizontal, .bottom], UIConstants.margin)
                .padding(.bottom, 80)
            }
            
            CenteredLongButton(
                text: "Add Attachment",
                foreground: .secondary,
                background: Color(.quaternarySystemFill)
            )
            .opacity(0)
            .padding(.bottom, UIConstants.margin)
        }
        .overlay(
            VStack(spacing: 0) {
                LinearGradient(colors: [Color.primaryBackground, Color.primaryBackground.opacity(0)], startPoint: .bottom, endPoint: .top)
                    .padding(.horizontal, UIConstants.margin)
                    .frame(height: 80)
                
                HStack(spacing: 16) {
                    Spacer()
                    
                    Button(action: {
                        DispatchQueue.main.async {
                            imageModal = true
                        }
                    }) {
                        LongButton(
                            text: "Attachment L",
                            foreground: Color.accentColor,
                            background: Color(.quaternarySystemFill)
                        )
                    }
                    .buttonStyle(DefaultButtonStyle())
                    .sheet(isPresented: $imageModal) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                    }
                    
                    Button(action: {
               
                    }) {
                        LongButton(
                            text: "Submit L",
                            foreground: (toggledBugs || toggledFeedback || toggledLog || toggledHarmful) ? (colorScheme == .dark ? .white : Color(.systemBackground)) : .secondary,
                            background: (toggledBugs || toggledFeedback || toggledLog || toggledHarmful) ? Color.accentColor : Color(.quaternarySystemFill)
                        )
                    }
                    .disabled(!toggledBugs && !toggledFeedback && !toggledHarmful && !toggledLog)
                    .buttonStyle(DefaultButtonStyle())
                    
                    Spacer()
                }
                .padding(.bottom, UIConstants.margin)
                .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            }
            ,alignment: .bottom
        )
        .navigationBarTitle("Report", displayMode: .inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    hideKeyboard()
                }) {
                    CircleButton(symbol: "keyboard.chevron.compact.down", custom: false)
                }
                .buttonStyle(CardButtonStyle())
        )
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .onDisappear {
            hideKeyboard()
        }
    }
}
