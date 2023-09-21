//
//  Array.swift
//  PostBox
//
//  Created by b0kch01 on 12/31/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation

extension Array {
    /// Returns index or default value (provided) using subscript syntax
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}

extension Array where Element: Repo {
    /// Eliminates duplicates in a Repo Array
    var packageMerge: Array {
        var packages = [Element]()
        for package in self where !packages.contains(package) {
            packages.append(package)
        }
        
        return packages
    }
}

extension Array where Element: Hashable {
    /// Makes a set, finds the difference, and returns it as a list
    func difference(between other: [Element]) -> [Element] {
        let current = Set(self)
        return Array(current.symmetricDifference(other))
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise `nil`.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
