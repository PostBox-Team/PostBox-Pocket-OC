//
//  VersionHistory.swift
//  PostBox
//
//  Created by b0kch01 on 5/29/22.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct TimedPackageVersions: Identifiable, Comparable {
    static func < (lhs: TimedPackageVersions, rhs: TimedPackageVersions) -> Bool { lhs.id > rhs.id }
    static func == (lhs: TimedPackageVersions, rhs: TimedPackageVersions) -> Bool { lhs.id == rhs.id }
    
    let id: String
    
    var versions: [NewPackageVersion]
    
    var date: Date {
        Date(timeIntervalSince1970: Double(id) ?? 0)
    }
}

// swiftlint:disable identifier_name
struct NewPackageVersion: Identifiable, Comparable, Hashable {
    static func < (lhs: NewPackageVersion, rhs: NewPackageVersion) -> Bool { lhs.id < rhs.id }
    static func == (lhs: NewPackageVersion, rhs: NewPackageVersion) -> Bool { lhs.id == rhs.id }
    
    let id: String
    var from: String
    var to: String
}
