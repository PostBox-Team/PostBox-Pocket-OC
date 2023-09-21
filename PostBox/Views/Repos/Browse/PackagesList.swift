//
//  PackagesList.swift
//  PostBox
//
//  Created by b0kch01 on 11/11/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct PackagesList: View {
        
    @State var packages: [Package]
        
    private let packageCardType: PackageCard.PackageCardType
    
    private var title: String

    init(packages: [Package], cardType: PackageCard.PackageCardType = .packageListCard, title: String) {
        self._packages = State(initialValue: packages)
        self.packageCardType = cardType
        self.title = title
    }
    
    var body: some View {
        if #available(iOS 15, *) {
            packageList
                .padding(.horizontal, -UIConstants.margin)
        } else {
            packageList
        }
    }
    
    private var packageList: some View {
        List {
            ForEach(packages) { package in
                HStack {
                    PackageCard(package: package, type: packageCardType)
                        .buttonStyle(NoButtonStyle())
                        .contextMenu(menuItems: { package.contextMenu })
                    
                    NavigationLink(destination: PackageView(package)) {
                        EmptyView()
                    }
                    .frame(width: 0)
                    .opacity(0)
                }
            }
            .listRowBackground(Color.primaryBackground)
        }
        .id(UUID())
        .navigationBarTitle(Text(title), displayMode: .inline)
        .navigationBarItems(
            trailing:
                NavigationBarItems()
        )
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }
}
