//
//  FlexiableString.swift
//  PostBox
//
//  Created by b0kch01 on 11/19/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

/// A codable struct that can be represented as a String, Boolean, or Double
struct FlexibleString: Codable, Comparable {
    static func < (lhs: FlexibleString, rhs: FlexibleString) -> Bool { lhs.value < rhs.value }
    
    let value: String
    
    var numericalValue: CGFloat { CGFloat(Double(value) ?? 0) }
    var doubleGuess: Double? { Double(value) }
    var doubleCertain: Double { Double(value) ?? 0 }
    var boolValue: Bool { value == "true" || value == "1" }

    init(_ value: String) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let str = try? container.decode(String.self) {
            value = str
        } else if let double = try? container.decode(Double.self) {
            value = double.description
        } else if let bool = try? container.decode(Bool.self) {
            value = bool.description
        } else {
            throw DecodingError.typeMismatch(String.self, .init(codingPath: decoder.codingPath, debugDescription: ""))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
