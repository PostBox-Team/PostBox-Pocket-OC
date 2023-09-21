//
//  URLFunctions.swift
//  PostBox
//
//  Created by b0kch01 on 11/9/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import Foundation
import SafariServices

/// A collection of useful URL tools used in PostBox
struct URLFunction {
    /// Returns a `URL` from string (not an optional)
    static func url(_ string: String?=nil) -> URL {
        if let string {
            return URL(string: string) ?? URL(string: "https://127.0.0.1")!
        }
        return URL(string: "https://127.0.0.1")!
    }

    /// Returns a cleaned `URL` from string (not an optional)
    static func cleanURL(_ string: String?=nil) -> URL {
        return url(clean(string))
    }

    /// Takes a URL and appends `https://` if applicable and removes whitespaces and newlines; enforces consitent URLs
    static func clean(_ url: String?=nil) -> String {
        guard let url = url, url.count > 1 else { return "https://127.0.0.1" }

        let protocolPrefix = url.hasPrefix("apt.thebigboss.org") || url.hasPrefix("apt.saurik.com") ? "http://" : "https://"
        var newURL = (URLFunction.valid(url) ? "" : protocolPrefix) + url

        if url.hasSuffix("/") {
            newURL = String(url.dropLast())
        }
        
        return newURL.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Combines two URLs
    static func join(_ base: String, _ second: String) -> String {
        base + (base.hasSuffix("/") ? "" : "/") + (second.hasPrefix("/") ? String(second.dropFirst(1)) : second)
    }
    /// Checks if string is valid for URL (basic checks)
    static func valid(_ url: String) -> Bool {
        url.lowercased().hasPrefix("http://") || url.lowercased().hasPrefix("https://")
    }
    /// Creates malto URL from string
    static func email(_ address: String) -> URL? {
        let cleaned = address.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "mailto:\(cleaned)") {
            return url
        }
        return nil
    }
    /// Creates a valid APT GET Request for repos
    static func aptRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        
        request.setValue("PostBox by simplycode.", forHTTPHeaderField: "User-Agent")
        request.setValue(Device.model(), forHTTPHeaderField: "X-Machine")
        request.setValue(Device.udid, forHTTPHeaderField: "X-Unique-ID")
        request.setValue(Device.version, forHTTPHeaderField: "X-Firmware")

        return request
    }
}
