//
//  RepoMarket.swift
//  PostBox
//
//  Created by b0kch01 on 2/15/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import Foundation

class LazyImplementationOfStore {
    
    // Globally accessible store information (dangerous, ik)
    static var loaded  = false
    static var tokens  = Defaults.dictionary(forKey: "repo-tokens") as? [String: String] ?? [:]
    static var secrets = [String: String]()

    static func makeRequest(url: String) -> URLRequest? {
        guard let urlObj = URL(string: url) else { return nil }

        let params = [
            "token": LazyImplementationOfStore.tokens[url] ?? "",
            "udid": Device.udid,
            "device": Device.model()
        ]

        guard let paramData = try? JSONSerialization.data(withJSONObject: params) else { return nil }
        
        var request = URLRequest(url: urlObj)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
    
    static func setToken(repo: Repo, token: String) {
        LazyImplementationOfStore.tokens[repo.url] = token
        Defaults.set(LazyImplementationOfStore.tokens, forKey: "repo-tokens")
    }
    
    static func remove(repo: Repo?) {
        if let repo = repo {
            LazyImplementationOfStore.tokens.removeValue(forKey: repo.url)
            LazyImplementationOfStore.secrets.removeValue(forKey: repo.url)
            Defaults.set(LazyImplementationOfStore.tokens, forKey: "repo-tokens")
        }
    }
    
    static func setSecret(repo: Repo, secret: String) {
        LazyImplementationOfStore.tokens[repo.url] = secret
    }
}

struct Download: Codable {
    var url: String?
    var error: String?
}

struct RepoMarket {
    var endpoint = ""
    var description = ""
    var bannerMessage = ""
    var bannerButton = ""
    var username = ""
    var paidPackages = [String]()
}

// MARK: - JSON Objects
struct PaymentProviderData {
    
    /// Struct representing Sileo's `/info` endpoint
    struct Info: Codable {
        var name: String
        var icon: String
        var description: String
        var authentication_banner: AuthBanner
        
        struct AuthBanner: Codable {
            var message: String
            var button: String
        }
    }
    
    /// Struct representing Sileo's `/user_info` endpoint
    struct User: Codable {
        var items: [String]
        var user: Contact
    }
    
    /// Struct to get sucess callback
    struct Success: Codable {
        var success: Bool
    }
    
    /// Struct representing Sileo's `package/:package_id/info` endpoint
    struct PackageInfo: Codable {
        var price: FlexibleString
    }
}
