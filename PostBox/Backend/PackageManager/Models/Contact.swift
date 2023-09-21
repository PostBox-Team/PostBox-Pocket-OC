//
//  Contact.swift
//  PostBox
//
//  Created by b0kch01 on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation

/// Codable struct used for `Package`maintainer / author fields
struct Contact: Codable {
    
    var name: String
    var email: String
    
    init(name: String? = nil, email: String? = nil) {
        self.name = name ?? "Unknown"
        self.email = email ?? ""
    }
    
    init(_ contactString: String) {
        self.name = "Unknown"
        self.email = ""
        
        if contactString.count == 0 { return }
        
        if !contactString.contains("<") {
            self.name = contactString
            return
        }
        
        var matches = contactString.groups(for: "(.+) <(.+)>")
        
        if matches.count > 0 && matches[0].count > 0 {
            self.name = matches[0].removeFirst()
            self.email = matches[0].first ?? ""
            
            return
        }
    }
}
