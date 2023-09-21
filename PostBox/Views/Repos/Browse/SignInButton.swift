//
//  SignInButton.swift
//  PostBox
//
//  Created by b0kch01 on 1/31/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import BetterSafariView

struct SignInButton: View {

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var repo: Repo

    /// Market stuff
    @Binding var loggedIn: Bool
    @State var confirmLogout = false
    @State var doAction = false

    var body: some View {
        Button(action: {
            if loggedIn {
                confirmLogout.toggle()
            } else {
                doAction.toggle()
            }
        }) {
            HStack(spacing: 0) {
                Text(
                    loggedIn ?
                    "You are now logged in! Store features are still in beta." : repo.market.bannerMessage
                )
                    .font(.system(size: Types.footnote))
                    .fontWeight(.regular)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Image(systemName: loggedIn ? "checkmark" : "chevron.right")
                    .font(.system(size: Types.subheadline).weight(.medium))
                    .foregroundColor(Color(.tertiaryLabel))
                    .padding(.horizontal, 3)
            }
            .padding(16)
            .background(Color(.quaternarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        }
        .buttonStyle(CardButtonStyle())
        .alert(isPresented: $confirmLogout) {
            Alert(
                title: Text("Do you want to logout?"),
                message: Text("You are about to logout from \(repo.name). You will need to log back in to download any purchased packages from this repo."),
                primaryButton: Alert.Button.destructive(Text("Logout"), action: {
                    repo.logout { loggedIn = false }
                }),
                secondaryButton: Alert.Button.cancel(Text("Cancel"))
            )
        }
        .webAuthenticationSession(isPresented: $doAction) {
            WebAuthenticationSession(
                url: URL(
                    string: URLFunction.join(
                        repo.market.endpoint,
                        "authenticate?udid=\(Device.udid)&model=\(Device.model())"
                    )
                )!,
                callbackURLScheme: "sileo"
            ) { callbackURL, _ in

                let token = callbackURL?["token"] ?? ""
                let secret = callbackURL?["secret"] ?? ""

                if token.count > 0 {
                    LazyImplementationOfStore.setToken(repo: repo, token: token)
                    repo.getUserInfo()
                    loggedIn = true
                }

                if secret.count > 0 {
                    LazyImplementationOfStore.setSecret(repo: repo, secret: secret)
                }
            }
            .prefersEphemeralWebBrowserSession(false)
        }
    }
}
