//
//  PackageFetchDepictions.swift
//  PostBox
//
//  Created by b0kch01 on 7/29/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI

extension Package {
    /// Loads native depiction data
    func loadSileoDepictions(completion: ((Color) -> Void)?) {
        loadPrice()
        
        if sileoDepictionsLoaded && sileoDepiction.tabs != nil {
            if let completed = completion {
                if Defaults.bool(forKey: "setting-colorful-depicts"), let tintColor = sileoDepiction.tintColor, tintColor.count > 0 {
                    completed(Color(hex: tintColor))
                } else {
                    completed(.primary)
                }
            }
            return
        }
        
        if let url = URL(string: sileoDepictionURL) {
            log("🧧 Loading Depictions:", url)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else { return }
                
                do {
                    let json = try JSONDecoder().decode(SileoDepiction.self, from: data)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.sileoDepiction = json
                        self?.sileoDepictionsLoaded = true
                        
                        if let completion {
                            if Defaults.bool(forKey: "setting-colorful-depicts"), let tintColor = self?.sileoDepiction.tintColor, tintColor.count > 0 {
                                completion(Color(hex: tintColor))
                            } else {
                                completion(.primary)
                            }
                        }
                    }
                } catch {
                    log("😕 \(url): \(error)")
                }
            }
            .resume()
        }
    }
}
