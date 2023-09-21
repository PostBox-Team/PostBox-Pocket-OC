//
//  DepictionScreenshotView.swift
//  PostBox
//
//  Created by b0kch01 on 11/15/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import AVKit
import URLImage

struct DepictionScreenshotsView: View {
    
    @State var show = false
    @State var animate = false
    
    var data: DepictionObjectView
    
    var maxX: Int { Int(UIScreen.main.bounds.maxX) }
    
    @ViewBuilder
    var smallScreenshots: some View {
        if let screenshots = data.screenshots {
            if Int(data.getSize()[0])*screenshots.count + 20*(screenshots.count - 1) + 40 < maxX {
                CenterHStack {
                    ForEach(screenshots.indices, id: \.self) { i in
                        Button(action: { show = true }) {
                            DepictionScreenshotView(
                                data: screenshots[i],
                                size: data.getSize(),
                                cornerRadius: CGFloat(data.cornerRadius ?? 10)
                            )
                        }
                        .buttonStyle(CardButtonStyle())
                        .padding(.trailing, i + 1 != screenshots.count ? 20 : 0)
                    }
                }
                .padding(20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: UIConstants.margin) {
                        ForEach(screenshots.indices, id: \.self) { i in
                            Button(action: { show = true }) {
                                DepictionScreenshotView(
                                    data: screenshots[i],
                                    size: data.getSize(),
                                    cornerRadius: CGFloat(data.cornerRadius ?? 10)
                                )
                            }
                            .buttonStyle(CardButtonStyle())
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
    
    @ViewBuilder
    var body: some View {
        smallScreenshots
            .onAppear { animate = true }
            .sheet(isPresented: $show) { view }
    }
    
    var view: some View {
        VStack(spacing: 0) {
            SplashHeader("Screenshot")
                .padding(.horizontal, UIConstants.margin)
            
            if let screenshots = data.screenshots {
                if maxX*Int(data.getSize()[0])/Int(data.getSize()[1])*screenshots.count + 20*(screenshots.count-1) + 40 < maxX {
                    CenterHStack {
                        ForEach(screenshots.indices, id: \.self) { i in
                            DepictionScreenshotView(
                                data: screenshots[i],
                                size: [999999, UIScreen.main.bounds.height - UIConstants.margin*2 - 30],
                                cornerRadius: CGFloat(data.cornerRadius ?? 10)
                            )
                            .padding(.trailing, i + 1 != screenshots.count ? 20 : 0)
                        }
                    }
                    .padding(UIConstants.margin)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: UIConstants.margin) {
                            ForEach(screenshots.indices, id: \.self) { i in
                                DepictionScreenshotView(
                                    data: screenshots[i],
                                    size: [999999, UIScreen.main.bounds.height - UIConstants.margin*3 - 30],
                                    cornerRadius: CGFloat(data.cornerRadius ?? 10)
                                )
                            }
                        }
                        .padding(UIConstants.margin)
                    }
                }
            }
        }
    }
}
struct DepictionScreenshotView: View {
    
    private var data: Screenshot
    private var width: CGFloat
    private var height: CGFloat
    private var cornerRadius: CGFloat
    
    init(data: Screenshot, size: [CGFloat], cornerRadius: CGFloat) {
        self.data = data
        self.width = size[0]
        self.height = size[1]
        self.cornerRadius = cornerRadius
    }
    
    @ViewBuilder
    var body: some View {
        if let url = URL(string: URLFunction.clean(data.url)) {
            if data.video == true {
                PostBoxVideoPlayer(url: .constant(url))
                    .frame(width: min(width, UIScreen.main.bounds.maxX-60))
                    .frame(maxHeight: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            } else if data.video != true {
                URLImage(
                    url: url,
                    empty: {
                        Text(data.accessibilityText)
                    }, inProgress: { _ in
                        Color.accentColor
                    }, failure: { _, _ in
                        Color.accentColor
                    }, content: { image in
                        image.renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                )
                .frame(width: min(width, UIScreen.main.bounds.maxX-60), height: height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(Color(.tertiaryLabel), lineWidth: 1)
                        .opacity(0.3)
                )
            }
        }
    }
}
