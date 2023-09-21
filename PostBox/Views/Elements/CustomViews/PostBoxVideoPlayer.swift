//
//  PostBoxVideoPlayer.swift
//  PostBox
//
//  Created by Polarizz on 12/26/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import AVKit

struct PostBoxVideoPlayer: UIViewControllerRepresentable {

    @Binding var url: URL

    private var player: AVPlayer { AVPlayer(url: url) }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.videoGravity = .resizeAspectFill
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController { AVPlayerViewController() }
}
