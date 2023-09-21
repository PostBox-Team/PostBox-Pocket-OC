//
//  RepoMarket.swift
//  PostBox
//
//  Created by b0kch01 on 7/24/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

extension Repo {
    // MARK: - Market Store Functions
    
    /// Gets Sileo API endpoint, returns it, and stores it. Make sure group.leave is in the completion function (if applicable)
    public func getEndpoint(group: DispatchGroup?=nil, completion: (() -> Void)? = nil) {
        guard let url = URL(string: URLFunction.join(url, "payment_endpoint")) else {
            group?.leave()
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10 // Max 10 seconds to load endpoint
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.global(qos: .utility).async {
                guard let data = data,
                      let endpointString = String(data: data, encoding: .utf8)
                else {
                    group?.leave()
                    return
                }
                
                if !endpointString.hasPrefix("https://") {
                    group?.leave()
                    return
                }
            
                DispatchQueue.main.async { [weak self] in
                    self?.market.endpoint = URLFunction.clean(endpointString)
                    if let self = self { RepoManager.reposCached[self.url] = self }
                    log("💰 Store Found!: \(endpointString)")
                    completion?()
                }
            }
        }
        .resume()
    }
    
    /// Get Sileo API info endpoint, reutnrs it, and stores it. Make sure group.leave is in the completion function (if applicable)
    public func getStoreInfo(group: DispatchGroup?=nil, completion: (() -> Void)? = nil) {
        let endpoint = market.endpoint
        guard let url = URL(string: URLFunction.join(endpoint, "info")) else {
            group?.leave()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.global(qos: .utility).async {
                guard let data = data,
                      let info = try? JSONDecoder().decode(PaymentProviderData.Info.self, from: data)
                else {
                    group?.leave()
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.market.description = info.description
                    self?.market.bannerMessage = info.authentication_banner.message
                    self?.market.bannerButton = info.authentication_banner.button
                    if let self = self { RepoManager.reposCached[self.url] = self }
                    log("👍 Store Loaded:", endpoint)
                    completion?()
                }
            }
        }
        .resume()
    }
    
    /// Gets enpoint (if necessary) and store info and stores it. Make sure group.leave is in the completion function (if applicable)
    public func loadMarket(group: DispatchGroup?=nil, completion: (() -> Void)? = nil) {
        if market.endpoint == "" {
            getEndpoint(group: group) { [weak self] in
                guard let self = self else {
                    group?.leave()
                    return
                }
                self.getStoreInfo(group: group) { completion?() }
            }
        } else {
            getStoreInfo(group: group) { completion?() }
        }
    }
    
    /// Gets the user data from repo and stores it
    public func getUserInfo(group: DispatchGroup?=nil, completion: (() -> Void)? = nil) {
        let endpoint = market.endpoint
        if endpoint.count == 0 {
            group?.leave()
            return
        }
        
        let urlCached = url
        let params = [
            "token": LazyImplementationOfStore.tokens[url] ?? "",
            "udid": Device.udid,
            "device": Device.model()
        ]
        
        guard let urlReq = URL(string: URLFunction.join(endpoint, "user_info")),
              let paramData = try? JSONSerialization.data(withJSONObject: params)
        else {
            group?.leave()
            return
        }
        
        var request = URLRequest(url: urlReq)
        
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.global(qos: .utility).async {
                guard let data = data,
                      let userData = try? JSONDecoder().decode(PaymentProviderData.User.self, from: data)
                else {
                    group?.leave()
                    log("❌ Couldn't grab payment data for \(urlCached)")
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.market.username = userData.user.name
                    self?.market.paidPackages = userData.items.map { $0 + urlCached }
                    if let self = self { RepoManager.reposCached[self.url] = self }
                    log("👍 Store Userdata Loaded:", endpoint, userData)
                    completion?()
                }
            }
        }
        .resume()
    }
    
    /// Invalidates logged in session, removes it locally
    public func logout(completion: (() -> Void)? = nil) {
        let endpoint = market.endpoint
        let params = [
            "token": LazyImplementationOfStore.tokens[url] ?? "",
            "udid": Device.udid,
            "device": Device.model()
        ]
        
        guard let urlReq = URL(string: URLFunction.join(endpoint, "sign_out")),
              let paramData = try? JSONSerialization.data(withJSONObject: params)
        else { return }
        
        var request = URLRequest(url: urlReq)
        
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.global(qos: .utility).async {
                guard let data = data,
                      let success = try? JSONDecoder().decode(PaymentProviderData.Success?.self, from: data)
                else { return }
                
                if success.success == true {
                    DispatchQueue.main.async { [weak self] in
                        LazyImplementationOfStore.remove(repo: self)
                        self?.market.username = ""
                        self?.market.paidPackages = []
                        completion?()
                    }
                }
            }
        }
        .resume()
    }
}
