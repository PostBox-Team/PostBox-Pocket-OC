//
//  CreditsView.swift
//  PostBox
//
//  Created by Polarizz on 11/16/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import BetterSafariView

private struct CreditRow: View {
    var title: String
    var url: String
    
    init(_ title: String, _ url: String) {
        self.title = title
        self.url = url
    }
    
    var body: some View {
        Button(action: { UIApplication.shared.open(URL(string: url)!) }) {
            Text(title)
                .font(.system(size: Types.subheadline))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
    }
}

struct CreditsView: View {
    
    @State private var counter: Int = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                if #available(iOS 14.0, *) {
                    Text("PostBox")
                        .font(.system(.title, design: .serif).weight(.semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .confettiCannon(counter: $counter, confettis: [.sfSymbol(symbolName: "heart.fill")], colors: [.pink], openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                        .padding(.bottom, 30)
                } else {
                    Text("PostBox")
                        .font(.system(.title, design: .serif).weight(.semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                }
                
                VStack(alignment: .center, spacing: 7) {
                    Text("Made By")
                        .font(.subheadline.weight(.semibold))
                    
                    Text("b0kch01")
                        .font(.system(size: Types.subheadline))
                    
                    Text("Polarizz")
                        .font(.system(size: Types.subheadline))
                }
                
                Bar()
                    .padding(.vertical, 30)
                
                VStack(alignment: .center, spacing: 7) {
                    Text("Special Thanks")
                        .font(.subheadline.weight(.semibold))
                    
                    CreditRow("Sileo Team's Open Source Code", "https://github.com/Sileo/Sileo")
                    CreditRow("RuntimeOverflow's brain", "https://twitter.com/runtimeoverflow")
                    CreditRow("Alpha's bug finding", "https://github.com/TheAlphaStream")
                    CreditRow("Wildchild9's Regex extension", "https://forums.swift.org/t/regular-expressions-in-swift/34373/4")
                    CreditRow("Vyacheslav's Regex Grouping function", "https://stackoverflow.com/a/53652037")
                    CreditRow("Shuga's DepictionTester", "https://repotest.shuga.co")
                    CreditRow("SailyTeam's RepoManager.swift", "https://github.com/SailyTeam/Saily")
                    CreditRow("Repo Updates's Popular Repos list", "https://ios-repo-updates.com")
                    CreditRow("Simon Bachmann's ConfettiSwiftUI", "https://github.com/simibac/ConfettiSwiftUI")
                }
                
                Bar()
                    .padding(.vertical, 30)

                VStack(alignment: .center, spacing: 7) {
                    Text("Ready when b0kch01 is.")
                    Text("notapackagemanager")
                }
                .font(.system(size: Types.subheadline))
                
                Spacer()
            }
            .padding(.top, UIConstants.margin)
            .padding(UIConstants.margin)
        }
        .navigationBarTitle("", displayMode: .inline)
        .background(
            Color.primaryBackground
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            Haptics.shared.notify(.success)
            counter += 1
        }
    }
}
