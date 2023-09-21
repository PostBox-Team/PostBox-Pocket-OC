//
//  HomeViewiOS15.swift
//  PostBox
//
//  Created by Polarizz on 6/3/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
 
/// HomeViewiOS15 and HomeViewInneriOS15 must be split due to UI issues.

@available(iOS 15.0, *)
struct HomeViewiOS15: View {
        
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            HomeViewInneriOS15(
                searchText: $searchText
            )
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

@available(iOS 15.0, *)
struct HomeViewInneriOS15: View {
    
    @Environment(\.isSearching) var isSearching

    @Binding var searchText: String
    
    var body: some View {
        ZStack {
            Group {
                if searchText == "" {
                    SearchEmpty()
                } else {
                    SearchView(search: searchText)
                }
            }
            .opacity(isSearching ? 1 : 0)
            
            HomeViewInner()
                .opacity(isSearching ? 0 : 1)
        
        }
    }
}
