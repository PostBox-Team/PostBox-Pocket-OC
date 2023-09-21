//
//  PackagePrice.swift
//  PostBox
//
//  Created by b0kch01 on 7/29/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

extension Package {
    // MARK: - Package price from repo store API
    
    /// Package price as a String; returns "FREE" if `priceNum` is 0
    var price: String {
        let preferredLanguage = NSLocale.preferredLanguages[0]

        if preferredLanguage == "zh-Hans" {
            if priceNum == 0 {
                return "免费"
            } else if priceNum < 0 {
                return "付费"
            }
        } else if preferredLanguage == "zh-Hant" {
            if priceNum == 0 {
                return "免費"
            } else if priceNum < 0 {
                return "付費"
            }
        } else {
            if priceNum == 0 {
                return "Free"
            } else if priceNum < 0 {
                return "Paid"
            }
        }
        
        return String(format: "%.2f", priceNum)
    }
    
    /// Package price with dollar sign
    var priceStr: String {
        return (priceNum > 0 ? "$" + price : price)
    }
    
    internal func updatePrice(flexibleString: FlexibleString) {
        if let num = flexibleString.doubleGuess {
            priceNum = num
        } else if flexibleString.value.hasPrefix("$") {
            priceNum = Double(flexibleString.value.dropFirst(1)) ?? -2
        } else {
            priceNum = -2
        }
    }

    /// Loads market price if is paid package
    func loadPrice(completion: (() -> Void)?=nil) {
        log("💵 Loading price for", identifier)
        if priceNum == -1 {
            if !tags.contains("cydia::commercial") {
                priceNum = 0
                completion?()
                return
            }
            
            if let endpoint = sileoEndpoint {
                let urlString = URLFunction.join(endpoint, "package/\(self.identifier)/info")
                
                guard let request = LazyImplementationOfStore.makeRequest(url: urlString) else { return }
                
                URLSession.shared.dataTask(with: request) { data, _, _ in
                    guard let data = data else { return }
                    guard let info = try? JSONDecoder().decode(PaymentProviderData.PackageInfo.self, from: data) else { return }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.updatePrice(flexibleString: info.price)
                        completion?()
                    }
                }.resume()
            } else {
                URLSession.shared.dataTask(with: URL(string: URLFunction.join(repoURL, "payment_endpoint"))!) { [weak self] data, _, _ in
                    guard let data = data else { return }
                    guard let endpoint = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                    
                    self?.sileoEndpoint = endpoint
                    
                    guard let id = self?.identifier else { return }
                    
                    let urlString = URLFunction.join(endpoint, "package/\(id)/info")
                    guard var request = LazyImplementationOfStore.makeRequest(url: urlString) else { return }
                    
                    self?.updatePriceUI(with: request) { success in
                        if success {
                            completion?()
                        } else {
                            request.httpBody = nil
                            self?.updatePriceUI(with: request) { _ in
                                completion?()
                            }
                        }
                    }
                }.resume()
            }
        } else {
            completion?()
        }
    }
    
    /// Updates UI for price
    private func updatePriceUI(with request: URLRequest, completion: ((Bool) -> Void)?=nil) {
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion?(false)
                return
            }
            
            do {
                let info = try JSONDecoder().decode(PaymentProviderData.PackageInfo.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    self?.updatePrice(flexibleString: info.price)
                    completion?(true)
                }
            } catch {
                log("❌ Error getting package price (\(request.httpMethod ?? "nil"):", error, request)
                completion?(false)
            }
        }.resume()
        
    }
}
