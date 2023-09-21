//
//  MiniDepiction.swift
//  PostBox
//
//  Created by b0kch01 on 11/22/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct MiniDepictionView: View {
    
    @Environment(\.presentationMode) var modal
    
    @State private var data = DepictionObjectView()
    @State private var loading = true
    @State private var failed = false
    
    private let color: String
    private let url: URL
    
    init(with url: URL, color: String) {
        self.color = color
        self.url = url
    }
    
    @ViewBuilder
    private var items: some View {
        if loading == true {
            ActivityIndicator()
                .onAppear {
                    let request = URLFunction.aptRequest(for: url)
                    
                    URLSession.shared.dataTask(with: request) { unsafeData, _, error in
                        guard let safeData = unsafeData else {
                            failed = true
                            loading = false
                            return log("❌ Couldn't load additional depiction: \(url.absoluteString) - \(String(describing: error?.localizedDescription))")
                        }
                        
                        do {
                            data = try JSONDecoder().decode(DepictionObjectView.self, from: safeData)
                        } catch {
                            failed = true
                            log("❌ Couldn't parse JSON: \(error)")
                        }
                        
                        loading = false
                    }
                    .resume()
                }
        } else if let views = data.views {
            ScrollView {
                DepictionStackView(views: views, landscape: false, color: color, stacked: false, inModal: true)
            }
        } else {
            Text("Something went wrong.")
                .font(.headline)
        }
    }
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            items
                .navigationBarTitle(data.title ?? "Depiction")
        }
    }
}
