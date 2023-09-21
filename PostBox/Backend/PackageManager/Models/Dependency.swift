//
//  Dependency.swift
//  PostBox
//
//  Created by b0kch01 on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation

/// Codable struct used for `Package`dependencies
struct Dependency: Identifiable, Codable {
    
    var id: String
    var version: String
    
    init(id: String? = nil, version: String? = nil) {
        self.id = id ?? "Unknown"
        self.version = version ?? "Unknown"
    }
    
    init(_ depString: String) {
        var matches = depString.groups(for: "(.+) (\\(.+\\))")
        
        if matches.count > 0 && matches[0].count > 0 {
            self.id = matches[0].removeFirst()
            self.version = matches[0].first ?? ""
            
            return
        }
        
        self.id = "Unknown"
        self.version = ""
    }
}
