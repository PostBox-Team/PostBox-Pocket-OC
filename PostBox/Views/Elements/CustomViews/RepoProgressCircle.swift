//
//  RepoProgressCircle.swift
//  PostBox
//
//  Created by b0kch01 on 11/12/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct RepoProgressCircle: View {
    
    @Binding var finishedAll: Bool
    @Binding var progress: [String: Double]
    @Binding var state: [String: PackageManager.RefreshState]
    
    private var id: String
    private var restingIcon: String
    private var restingColor: Color
    
    init(
        finishedAll: Binding<Bool>,
        progress: Binding<[String: Double]>,
        state: Binding<[String: PackageManager.RefreshState]>,
        id: String? = nil,
        restingIcon: String? = nil,
        color: Color? = nil
    ) {
        self._finishedAll = finishedAll
        self._progress = progress
        self._state = state
        
        self.id = id ?? "all"
        self.restingIcon = restingIcon ?? "xmark.app.fill"
        self.restingColor = color ?? .red
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(
                    width: Types.title3,
                    height: Types.title3
                )
                .opacity(0)
            
            if !finishedAll {
                Image(restingIcon)
                    .foregroundColor(restingColor)
                    .font(.system(size: Types.title3))
                    .transition(.scale)
            } else if state[id] == .done {
                Image("checkmark.app.fill")
                    .foregroundColor(Color.accentColor)
                    .font(.system(size: Types.title3))
                    .transition(.scale)
            } else if state[id] == .error {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: Types.title3))
                    .transition(.scale)
            } else {
                ZStack(alignment: .center) {
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color(.quaternarySystemFill))
                        .transition(.scale)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(progress[id] ?? 0.0, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.accentColor)
                        .rotationEffect(Angle(degrees: 270.0))
                        .transition(.scale)
                }
                .frame(
                    width: UIFont.preferredFont(forTextStyle: .body).pointSize+1,
                    height: UIFont.preferredFont(forTextStyle: .body).pointSize+1
                )
            }
        }
        .animation(Animation.spring(response: 0.39, dampingFraction: 1), value: finishedAll)
        .animation(Animation.spring(response: 0.39, dampingFraction: 1), value: progress)
        .animation(Animation.spring(response: 0.39, dampingFraction: 1), value: state)
    }
}
