//
//  StoreListItem.swift
//  PostBox
//
//  Created by b0kch01 on 4/17/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import BetterSafariView

struct StoreListItem: View {
    
    @State var doAction = false
    @State var navigate = false
    
    @ObservedObject var repo: Repo
    
    var packagesList: [Package] {
        repo.market.paidPackages.compactMap {
            PackageManager.packages[$0]
        }
    }
    
    var body: some View {
        Button(action: {
            if repo.loggedIn {
                navigate = true
            } else {
                doAction = true
            }
        }) {
            HStack(alignment: .center, spacing: 0) {
                repo.iconViewCard
                    .frame(width: 45, height: 45)
                    .background(Color(.quaternarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: Package.appCornerRadius(width: 45), style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: Package.appCornerRadius(width: 45), style: .continuous)
                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                            .opacity(0.3)
                    )
                    .padding(.trailing, 16)
                            
                VStack(alignment: .leading, spacing: 3) {
                    Text(repo.name)
                        .font(.system(size: Types.callout))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Text(repo.urlNoProtocol)
                        .font(.system(size: Types.subheadline))
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .fixedSize(horizontal: false, vertical: true)

                Spacer()

                InstallButton(
                    "arrow.up.forward.app.fill",
                    Color(.tertiaryLabel)
                )
                .padding(.trailing, 5)
            }
            .padding(.vertical, 11)
            .padding(.horizontal, UIConstants.margin)
            .background(
                NavigationLink(
                    "", destination: PackagesList(packages: packagesList, title: "Purchased"),
                    isActive: $navigate
                )
                    .opacity(0)
                    .disabled(true)
            )
            .background(Color.primaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        }
        .buttonStyle(NoButtonStyle())
        .contentShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
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
                }
                
                if secret.count > 0 {
                    LazyImplementationOfStore.setSecret(repo: repo, secret: secret)
                }
            }
            .prefersEphemeralWebBrowserSession(false)
        }
    }
}
