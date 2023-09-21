//
//  ImportingRepos.swift
//  PostBox
//
//  Created by b0kch01 on 2/1/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct ImportRepos {
    static func getPasteboardSources() -> [Repo] {
        var repos = [String]()
        
        if var strings = UIPasteboard.general.string, strings.count > 0 {
            strings = strings.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Order is important here
            let deliminers = [",\n", ";\n", ",", ";", "\n", " "]
            
            for d in deliminers where strings.contains(d) {
                repos = strings.components(separatedBy: d)
                return repos.map { Repo(url: URLFunction.clean($0), name: "New Repo") }
            }
            
            return [Repo(url: URLFunction.clean(strings), name: "New Repo")]
        }
        
        return []
    }
}
