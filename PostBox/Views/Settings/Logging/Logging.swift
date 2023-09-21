//
//  Logging.swift
//  PostBox
//
//  Created by b0kch01 on 12/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ShortLog: View {
    
    @State var log = Log.log.suffix(4)
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 0) {
            Text(log.joined().trimmingCharacters(in: .whitespacesAndNewlines))
                .font(.system(.caption, design: .monospaced))
                .multilineTextAlignment(.leading)
                .lineSpacing(3)
                .onReceive(timer) { _ in
                    if log == Log.log.suffix(4) { return }
                    withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                        log = Log.log.suffix(4)
                    }
                }
            
            Spacer()
        }
        .mask(LinearGradient(colors: [Color.black, Color.clear], startPoint: .bottom, endPoint: .top))
    }
}

struct Log: View {
    
    @State var log = Log.log
    
    static var log = [
#"""
 ▄▄▄·      .▄▄ · ▄▄▄▄▄▄▄▄▄·       ▐▄• ▄
▐█ ▄█▪     ▐█ ▀. •██  ▐█ ▀█▪▪      █▌█▌▪
 ██▀· ▄█▀▄ ▄▀▀▀█▄ ▐█.▪▐█▀▀█▄ ▄█▀▄  ·██·
▐█▪·•▐█▌.▐▌▐█▄▪▐█ ▐█▌·██▄▪▐█▐█▌.▐▌▪▐█·█▌
.▀    ▀█▄▀▪ ▀▀▀▀  ▀▀▀ ·▀▀▀▀  ▀█▄▀▪•▀▀ ▀▀

========= #notapostboxmanager =========


"""#
]
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
                Text(log.joined())
                    .font(.system(.caption, design: .monospaced))
                    .lineSpacing(3)

                Spacer()
            }
            .padding(UIConstants.margin)
        }
        .onReceive(timer) { _ in
            log = Log.log
        }
        .navigationBarTitle(LocalizedStringKey("App Log L"), displayMode: .inline)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
}

struct LogView: View {

    @State var log = Log.log
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            SplashHeader("App Log L")
                .padding(.horizontal, UIConstants.margin)
            
            ScrollView {
                HStack(spacing: 0) {
                    Text(log.joined())
                        .font(.system(.caption, design: .monospaced))
                        .lineSpacing(3)
                    
                    Spacer()
                }
                .padding(UIConstants.margin)
            }
            .onReceive(timer) { _ in
                log = Log.log
            }
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
}

func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
    DispatchQueue.main.async {
        Log.log.append(output + terminator)
    }
}
