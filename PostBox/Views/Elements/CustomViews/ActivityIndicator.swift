//
//  ActivityIndicator.swift
//  PostBox
//
//  Created by b0kch01 on 11/11/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
 
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
