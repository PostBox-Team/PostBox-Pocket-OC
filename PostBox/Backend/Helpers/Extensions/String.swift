//
//  ExString.swift
//  PostBox
//
//  Created by b0kch01 on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation
import SwiftUI

extension String {
    /// Easily match regex
    /// https://forums.swift.org/t/regular-expressions-in-swift/34373/4
    func matches<T>(_ pattern: T) -> Bool where T: StringProtocol {
        return self.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// Easily find groups  in regex
    /// https://stackoverflow.com/questions/42789953/swift-3-how-do-i-extract-captured-groups-in-regular-expressions
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(
                in: text,
                range: NSRange(text.startIndex..., in: text)
            )
            
            return matches.map { match in
                return (1..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            log("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    /// Regex replacing function
    func replace(_ regexPattern: String, template: String?=nil) -> String? {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            return regex.stringByReplacingMatches(
                in: text, options: [],
                range: NSRange(location: 0, length: text.count),
                withTemplate: template ?? ""
            )
        } catch {
            log("invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Truncates text and adds trailing string
    func trunc(_ length: Int, trailing: String = "...") -> String {
        return count > length ? prefix(length) + trailing : self
    }

    /// Removes control chars
    func removeControlChars() -> String {
        return self
            .replacingOccurrences(of: "&amp;nbsp;", with: "")
            .replacingOccurrences(of: "&amp;#x200B;", with: "")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")

    }
}

/// NSAttributedString height function
extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: containerWidth, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)           
    }
}
