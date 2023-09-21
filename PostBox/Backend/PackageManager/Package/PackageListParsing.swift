//
//  PackageListParsing.swift
//  PostBox
//
//  Created by b0kch01 on 7/29/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

extension Package {
    // MARK: - Functions that parse the debian metadata
    
    /// Grabs value from "Field: values"; used to parse Package file
    static func getRow(_ row: String, field: String) -> String? {
        return row.groups(for: field + ": (.+)[\n]?").first?.first
    }
    /// Splits the entire Packages file  intro blocks correctly
    static func split(_ string: String) -> [String] {
        return string.dropLast(
            string.hasSuffix("\n\n") ? 2 : 0
        )
        .components(separatedBy: "\n\n")
    }
}
