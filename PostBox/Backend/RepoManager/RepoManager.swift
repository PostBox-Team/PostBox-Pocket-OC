//
//  RepoManager.swift
//  PostBox
//
//  Created by b0kch01 on 11/10/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

/// ViewModel that handles all repository-related tasks
class RepoManager: ObservableObject {
    
    @Published var working = false
    
    /// Published property for the repos
    @Published var repos = [String: Repo]()
    
    /// Firebase instance
    var fdb = Firestore.firestore()
    
    /// Statically stored repoCache
    static var reposCached = [String: Repo]()
    
    /// Default repos
    static var defaultRepos = [
        "https://postbox.news"
    ]
    /// Sources which will be hidden in the repos list
    static var hiddenSources = ["apt.saurik.com", "apt.procurs.us", "apt.bingner.com", "old.nepeta.me"]
    
    init(packageManager: PackageManager) {
        if Defaults.value(forKeyPath: "repos") == nil {
            log("Adding default repos")
            addRepo(urls: RepoManager.defaultRepos) {
                packageManager.restoreCachedPackage {
                    sceneManager.present = sceneManager.action != ""
                    if Defaults.bool(forKey: "setting-auto-refresh") {
                        packageManager.refreshRepos()
                    }
                }
            }
        } else {
            sync(with: .userDefaults)
            packageManager.restoreCachedPackage {
                sceneManager.present = sceneManager.action != ""
                if Defaults.bool(forKey: "setting-auto-refresh") {
                    packageManager.refreshRepos()
                }
            }
        }
    }
    
    /// Source types:` .published`, `static`, `userDefaults`
    enum ReposDataType {
        case published
        case `static`
        case userDefaults
    }
    
    /// Syncs all other sources with the chosen source.
    /// Run after changing a repo list or initializing
    func sync(with type: ReposDataType, completion: (() -> Void)?=nil) {
        var truth = [String: Repo]()
        
        switch type {
        case .published: truth = repos
        case .static: truth = RepoManager.reposCached
        case.userDefaults:
            let repoURLs = Defaults.stringArray(forKey: "repos") ?? RepoManager.defaultRepos
            
            addRepo(urls: repoURLs)
            for repo in repoURLs {
                RepoManager.reposCached[repo] = Repo(url: repo)
            }
            completion?()
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.repos = truth
            RepoManager.reposCached = truth
            Defaults.set(self?.repos.map { $1.url }, forKey: "repos")
            completion?()
        }
    }
    
    /// Custom Adding repos
    static func customTask(url urlStr: String, completion: @escaping (Repo) -> Void) {
        guard let url = URL(string: RepoManager.releaseURL(for: urlStr)) else {
            DispatchQueue.main.async { completion(Repo(url: urlStr)) }
            return
        }

        let request = URLFunction.aptRequest(for: url)

        URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.global(qos: .utility).async {
                if let response = (response as? HTTPURLResponse)?.statusCode, response != 200 {
                    DispatchQueue.main.async {
                        completion(Repo(url: urlStr))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(Repo(url: urlStr))
                    }
                    return
                }
                
                let stringData = String(decoding: data, as: UTF8.self)
                DispatchQueue.main.async {
                    completion(Repo(url: urlStr, repoString: stringData))
                }
            }
        }
        .resume()
    }
    
    /// Adding repos
    func getTask(url urlStr: String, asyncTask: DispatchGroup) -> URLSessionDataTask? {
        guard let url = URL(string: RepoManager.releaseURL(for: urlStr)) else {
            log("❌ Failed to create task from invalid url: \(urlStr)")
            DispatchQueue.main.async { [weak self] in
                self?.repos[urlStr] = Repo(url: urlStr, name: urlStr, description: "Failed to load repo")
            }
            return nil
        }

        let request = URLFunction.aptRequest(for: url)
        
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.global(qos: .utility).async {
                if let response = (response as? HTTPURLResponse)?.statusCode, response != 200 {
                    DispatchQueue.main.async { [weak self] in
                        log("❌ Failed to get Release file from \(urlStr): \(error?.localizedDescription ?? "")")
                        self?.repos[urlStr] = Repo(url: urlStr, name: urlStr, description: "Failed to load repo")
                        asyncTask.leave()
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async { [weak self] in
                        log("❌ There is no data coming from \(url) \(error?.localizedDescription ?? "")")
                        self?.repos[urlStr] = Repo(url: urlStr, name: urlStr, description: "Failed to load repo")
                        asyncTask.leave()
                    }
                    return
                }
                
                let stringData = String(decoding: data, as: UTF8.self)
                
                DispatchQueue.main.async { [weak self] in
                    self?.repos[urlStr] = Repo(url: urlStr, repoString: stringData)
                    log("👍 Successfully added \(urlStr)")
                    asyncTask.leave()
                }
            }
        }
    }
    
    /// Adds multiple repos to the database
    func addRepo(urls: [String], completion: (() -> Void)? = nil) {
        if working {
            return
        }
        
        self.working = true
        DispatchQueue.global(qos: .utility).async {
            let asyncTasks = DispatchGroup()
            
            for urlRaw in urls {
                let url = URLFunction.clean(urlRaw)
                
                if self.repos[url] != nil {
                    log("⚠️ Repo already added: \(url)")
                    continue
                }
                
                if let task = self.getTask(url: url, asyncTask: asyncTasks) {
                    asyncTasks.enter()
                    DispatchQueue.main.async { [weak self] in
                        self?.repos[url] = Repo(url: url, name: url, description: "Loading repo")
                        task.resume()
                    }
                }
            }
            
            asyncTasks.notify(queue: .main) { [weak self] in
                self?.sync(with: .published)
                self?.working = false
                completion?()
            }
        }
    }
    
    /// Add a repo to the database
    func addRepo(url urlRaw: String, completion: (() -> Void)? = nil) {
        if working {
            completion?()
            return
        }

        if urlRaw == "Unknown" || urlRaw == "https://127.0.0.1" {
            log("⚠️ Repo is Unknown")
            completion?()
            return
        }
        
        let url = URLFunction.clean(urlRaw)
        if repos[url] != nil {
            log("⚠️ Repo already added: \(url)")
            completion?()
            return
        }
        
        self.working = true
        
        DispatchQueue.global(qos: .utility).async {
            let asyncTasks = DispatchGroup()
            
            if let task = self.getTask(url: url, asyncTask: asyncTasks) {
                asyncTasks.enter()
                DispatchQueue.main.async { [weak self] in
                    self?.repos[url] = Repo(url: url, name: url, description: "Loading repo")
                    task.resume()
                }
                
                asyncTasks.notify(queue: .main) { [weak self] in
                    self?.sync(with: .published)
                    self?.working = false
                    completion?()
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    completion?()
                    self?.working = false
                }
            }
        }
    }
    
    func removeRepo(url: String) {
        DispatchQueue.main.async { [weak self] in
            self?.working = true
            
            if self?.repos[url]?.name == nil {
                return
            }
            
            Defaults.removeObject(forKey: url)
            self?.repos.removeValue(forKey: url)
            self?.sync(with: .published)
            
            self?.working = false
            log("✌️ Removed repo: \(url)")
        }
    }
    
    private static func releaseURL(for baseURL: String) -> String {
        let baseURL = URLFunction.clean(baseURL)
        if
            baseURL == "https://apt.saurik.com" ||
            baseURL == "http://apt.saurik.com"
        {
            return "http://apt.saurik.com/dists/ios/Release"
        }
        
        if
            baseURL == "https://apt.thebigboss.org" ||
            baseURL == "http://apt.thebigboss.org" ||
            baseURL == "http://apt.thebigboss.org/repofiles/cydia" ||
            baseURL == "https://apt.thebigboss.org/repofiles/cydia"
        {
            return "http://apt.thebigboss.org/repofiles/cydia/dists/stable/Release"
        }
        
        if baseURL == "https://apt.procurs.us" {
            return "https://apt.procurs.us/dists/iphoneos-arm64/1700/main/binary-iphoneos-arm/Release"
        }
        
        if baseURL == "https://apt.bingner.com" || baseURL == "http://apt.bingner.com" {
            return "https://apt.bingner.com/dists/ios/1443.00/main/binary-iphoneos-arm/Release"
        }
        
        return URLFunction.join(String(baseURL), "Release")
    }
}
