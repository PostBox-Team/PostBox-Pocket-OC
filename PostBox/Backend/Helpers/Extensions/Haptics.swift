//
//  Haptics.swift
//  PostBox
//
//  Created by Polarizz on 5/11/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import UIKit

class Haptics {
    static let shared = Haptics()
    
    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
