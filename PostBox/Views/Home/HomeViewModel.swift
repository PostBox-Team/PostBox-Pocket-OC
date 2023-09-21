//
//  HomeViewModel.swift
//  PostBox
//
//  Created by Nathan Choi on 8/27/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    // I'm just getting lazy and idk if environment variables are worth it anymore
    static let shared = HomeViewModel()
    
    @Published private(set) var timeStyle: Int = Defaults.integer(forKey: "setting-time-type")
    
    public func setTimeStyle(_ type: Int) {
        timeStyle = type
        Defaults.set(type, forKey: "setting-time-style")
    }
}
