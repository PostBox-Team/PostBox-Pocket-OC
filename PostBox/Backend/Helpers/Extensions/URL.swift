//
//  URL.swift
//  PostBox
//
//  Created by b0kch01 on 3/27/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation

// Grabs param value using subscript notation
extension URL {
    subscript(query: String) -> String? {
        return URLComponents(
            url: self,
            resolvingAgainstBaseURL: false
        )?
            .queryItems?
            .first(where: { $0.name == query })?
            .value
    }
}
