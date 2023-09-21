//
//  PackageManager.swift
//  PostBox
//
//  Created by b0kch01 on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import SWCompression
import FirebaseFirestore

/// View model that handles all things packages
class PackageManager: ObservableObject {
    
    // MARK: - Repo refresh progress
    @Published var working = false
    
    var refreshProgress = [String: Progress]()
    var refreshStates   = [String: RefreshState]()
    var lastUpdated     = Date()
    
    // MARK: - Package download progress
    @Published var workingPackages = [Package]()
    @Published var downloadState   = [String: DownloadState]()
    var downloadProgress           = [String: Progress]()
    
    // MARK: - Main package database
    
    /// Default packages database
    static var packages             = [String: Package]()
    /// Packages that are not indexed in search; used for package cards in stories
    static var cachedPackages       = [String: Package]()
    /// Packages are grouped by repos
    static var packagesByRepo       = [String: [Package]]()
    
    static var prices               = [String: Double]()
    
    // MARK: - Package Version History
    @Published var versionHistory = [TimedPackageVersions]()
    
    /// Online database
    var fdb = Firestore.firestore()

    enum RefreshState {
        case downloading
        case done
        case adding
        case error
    }

    /// Safe storage before replacing the original
    private var packagesTemp = [String: Package]()

    /// Returns proper URL for getting Packages
    static func packagesURL(for baseURL: String) -> String {
        let baseURL = URLFunction.clean(baseURL)

        if baseURL == "https://apt.saurik.com" ||
            baseURL == "http://apt.saurik.com" {
            return "http://apt.saurik.com/dists/ios/main/binary-iphoneos-arm/Packages"
        }

        if baseURL == "https://apt.thebigboss.org" ||
            baseURL == "http://apt.thebigboss.org" ||
            baseURL == "http://apt.thebigboss.org/repofiles/cydia" ||
            baseURL == "https://apt.thebigboss.org/repofiles/cydia" {
            return "http://apt.thebigboss.org/repofiles/cydia/dists/stable/main/binary-iphoneos-arm/Packages"
        }

        if baseURL == "https://apt.procurs.us" {
            return "https://apt.procurs.us/dists/iphoneos-arm64/1700/main/binary-iphoneos-arm/Packages"
        }

        return URLFunction.join(baseURL, "Packages")
    }
    
    // MARK: - Functions

    /// Load packages locally on first load (cached)
    func restoreCachedPackage(completion: (() -> Void)?=nil) {
        log("😬 Building package database")
        let start = Date()
        working = true

        DispatchQueue.global(qos: .utility).async {
            let group = DispatchGroup()
            
            for repo in RepoManager.reposCached {
                if let packages = Defaults.stringArray(forKey: repo.key) {
                    group.enter()
                    self.addPackage(for: packages, repoURL: repo.key, group: group)
                }
            }

            group.notify(queue: .main) { [weak self] in
                if let packagesTemp = self?.packagesTemp {
                    PackageManager.packages = packagesTemp
                }
                self?.working = false
                completion?()
                log("😙 Built package database. Loaded \(PackageManager.packages.count) Packages in \(-start.timeIntervalSinceNow)s")
            }
        }
    }

    /// Generates recent packages list from data stored in UserDefaults
    func getVersionHistory(completion: (() -> Void)?=nil) {
        log("🌲 Loading version tree")
        
        DispatchQueue.global(qos: .utility).async {
            /// Holds a list of `NewPackageVersion`s for every timestamp
            var times = [String: [NewPackageVersion]]()
            
            for url in RepoManager.reposCached.keys {
                guard let allChangesFromRepo = Defaults.stringArray(forKey: "version-history-" + url) else {
                    continue
                }
                
                // Loops through different refreshTimeStamps
                for changeFromRepo in allChangesFromRepo {
                    /// Dictionary where key is the package ID
                    var newPackageVersions = [String: NewPackageVersion]()
                    
                    /// [
                    ///  1653890088.154881,
                    ///  com.simplycode.StoryTesterhttps://postbox.news;0.2,
                    ///  com.simplycode.PostBoxhttps://postbox.news;0.7
                    /// ]
                    let changesSplit = changeFromRepo.components(separatedBy: ";;")
                    
                    // Loop through the changes at a certain time of refresh, skipping the first
                    for i in 1..<changesSplit.count {
                        let change = changesSplit[i] /// "id;version"
                        let changeSplit = change.components(separatedBy: ";") /// [id, version]
                        
                        if changeSplit.count < 2 { continue }
                        
                        // New packages will have from and to the same, updated will have different
                        if newPackageVersions[changeSplit[0]] == nil {
                            newPackageVersions[changeSplit[0]] = NewPackageVersion(
                                id: changeSplit[0], from: changeSplit[1], to: changeSplit[1]
                            )
                        } else {
                            if newPackageVersions[changeSplit[0]]!.from < changeSplit[1] {
                                newPackageVersions[changeSplit[0]]!.to = changeSplit[1]
                            } else {
                                newPackageVersions[changeSplit[0]]!.from = changeSplit[1]
                            }
                        }
                    }
                    
                    // If list of versions already exists, then add on
                    guard var currentVersionList = times[changesSplit[0]] else {
                        times[changesSplit[0]] = Array(newPackageVersions.values)
                        continue
                    }
                    
                    currentVersionList += newPackageVersions.values
                    times[changesSplit[0]] = currentVersionList
                }
            }
            
            let timedPackageVersions: [TimedPackageVersions] = times.map { time, versions in
                TimedPackageVersions(id: time, versions: versions.sorted())
            }
                .sorted()
            
            DispatchQueue.main.async { [weak self] in
                self?.versionHistory = timedPackageVersions
                log("👍 Loaded version tree!")
                completion?()
            }
        }
    }
    
    /// Make sure packageStrings coming in is reversed
    func addPackage(for packageStrings: [String], repoURL: String, group: DispatchGroup) {
        DispatchQueue.main.async {
            Defaults.set(packageStrings, forKey: repoURL)
            
            self.refreshStates[repoURL] = .adding
            
            DispatchQueue.global(qos: .userInitiated).async {
                var packagesInRepo = [String: Package]()
                
                for packageString in packageStrings {
                    let package = Package(packageString: packageString, repoURL: repoURL)

                    if package.name == "Unknown" {
                        continue
                    }

                    guard let currentVersion = packagesInRepo[package.id]?.version else {
                        packagesInRepo[package.id] = package
                        continue
                    }

                    if currentVersion < package.version {
                        packagesInRepo[package.id] = package
                    }
                }
                
                DispatchQueue.main.async { [weak self] in
                    // Update static database
                    let packageArray = Array(packagesInRepo.values)
                    PackageManager.packagesByRepo[repoURL] = packageArray
                    
                    // Update dynamic database (pushes UI changes)
                    self?.packagesTemp.merge(packagesInRepo) { _, new in new }
                    
                    // Manage version history
                    let newVersions = packageArray.map { $0.id + ";" + $0.version }
                    let oldVersions = Defaults.stringArray(forKey: "latest-versions-" + repoURL) ?? []
                    let difference = oldVersions.difference(between: newVersions).sorted()
                    
                    // Update version log if there is a difference
                    if difference.count > 0 {
                        var versionHistory = Defaults.stringArray(forKey: "version-history-" + repoURL) ?? []
                        /// Current date rounded to the nearest minute so that most repos will be grouped together
                        let date = String(Int(Date().timeIntervalSince1970) / 100 * 100)
                        
                        versionHistory.insert(date + ";;" + difference.joined(separator: ";;"), at: 0)
                        Defaults.set(versionHistory, forKey: "version-history-" + repoURL)
                        Defaults.set(newVersions, forKey: "latest-versions-" + repoURL)
                    }
                    
                    self?.refreshStates[repoURL] = .done
                    group.leave()
                }
            }
        }
    }

    /// Refreshes all repos
    func refreshRepos(completion: (() -> Void)?=nil) {
        if self.working { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.working = true
            self?.packagesTemp = [String: Package]()
            
            let repos = Array(RepoManager.reposCached.keys)
            let reposTasks = DispatchGroup()

            for repo in repos {
                reposTasks.enter()
                self?.refreshStates[repo] = .downloading
                self?.refreshRepo(for: repo, task: reposTasks)
            }

            reposTasks.notify(queue: .main) {
                if let packagesTemp = self?.packagesTemp {
                    PackageManager.packages = packagesTemp
                }
                self?.working = false
                self?.lastUpdated = Date()

                log("✨ Finished refreshing all repos!")
                completion?()
            }
        }
    }

    func refreshRepo(for repoURL: String, completion: (([String: Package]) -> Void)?=nil) {
        if working { return }

        DispatchQueue.main.async { [weak self] in
            self?.working = true
            self?.refreshStates[repoURL] = .downloading
            
            let reposTasks = DispatchGroup()
            reposTasks.enter()
            self?.refreshRepo(for: repoURL, task: reposTasks)

            reposTasks.notify(queue: .main) { [weak self] in
                if let packagesTemp = self?.packagesTemp {
                    PackageManager.packages = packagesTemp
                    completion?(packagesTemp)
                }
                self?.working = false
                self?.lastUpdated = Date()
                log("✨ Finished refreshing \(repoURL)!")
            }
        }
    }
    
    /// Decompresses data for a variety of compression formats
    private static func decompress(data: Data, ext: String, url: URL) throws -> Data {
        if ext == "" { return data }
        
        log("⛏ Extracting \(url)")
        
        // Backup options if one is down/not extractable for whatever reason
        if ext == ".bz2" {
            return try BZipCompression.decompressedData(with: data)
        } else if ext == ".gz" {
            return try GzipArchive.unarchive(archive: data)
        } else if ext == ".xz" {
            return try XZArchive.unarchive(archive: data)
        } else if ext == ".lzma" {
            return try LZMA.decompress(data: data)
        }
        
        return data
    }

    private func runTask(for repoURL: String, ext: String, task currentTask: DispatchGroup, completion: @escaping () -> Void) {
        guard let url = URL(string: PackageManager.packagesURL(for: repoURL) + ext), URLFunction.valid(repoURL) else {
            completion()
            return
        }

        let urlRequest = URLFunction.aptRequest(for: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { dataCompressed, response, error in
            DispatchQueue.global(qos: .utility).async {
                if let response = (response as? HTTPURLResponse)?.statusCode, response != 200 {
                    completion()
                    return
                }

                guard let dataCompressed = dataCompressed else {
                    completion()
                    return
                }

                var data = dataCompressed

                do {
                    data = try PackageManager.decompress(data: data, ext: ext, url: url)
                } catch {
                    log("Failed to extract data from \(url): \(error)")
                    completion()
                    return
                }

                let packagesString = String(decoding: data, as: UTF8.self)
                self.addPackage(for: Package.split(packagesString), repoURL: repoURL, group: currentTask)

                log("📦 Loaded packages from \(url)")
            }
        }

        DispatchQueue.main.async { [weak self] in
            self?.refreshProgress[repoURL] = task.progress
            task.resume()
        }
    }

    /// Refreshes a single repo (Packages.bz2)
    private func refreshRepo(for repoURL: String, task reposTasks: DispatchGroup) {

        let dataTask = DispatchGroup()

        // I am so sorry...it had to be like this...
        dataTask.enter()
        runTask(for: repoURL, ext: ".bz2", task: dataTask) { [weak self] in
            self?.runTask(for: repoURL, ext: "", task: dataTask) {
                self?.runTask(for: repoURL, ext: ".lzma", task: dataTask) {
                    self?.runTask(for: repoURL, ext: ".xz", task: dataTask) {
                        self?.runTask(for: repoURL, ext: ".gz", task: dataTask) {
                            log("😕 Couldn't grab packages from \(repoURL)")
                            dataTask.leave()
                        }
                    }
                }
            }
        }

        dataTask.notify(queue: .global(qos: .background)) {
            reposTasks.leave()
        }
    }

    /// Final pass of repo refreshes a single repo (Packages)
    private func refreshRepoFinal(for repoURL: String, task dataTask: DispatchGroup) {
        guard let url = URL(string: PackageManager.packagesURL(for: repoURL)), URLFunction.valid(repoURL) else {
            log("❌ Couldn't used invalid url: \(repoURL)")
            dataTask.leave()
            return
        }

        let urlRequest = URLFunction.aptRequest(for: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let response = (response as? HTTPURLResponse)?.statusCode, response != 200 {
                log("❌ Failed connect to \(url): \(error?.localizedDescription ?? "")")
                dataTask.leave()
                return
            }

            guard let data = data else {
                log("❌ There is no raw package coming from \(url)")
                dataTask.leave()
                return
            }

            let packagesString = String(decoding: data, as: UTF8.self)
            let packages = Package.split(packagesString)
            self?.addPackage(for: packages, repoURL: repoURL, group: dataTask)
        }

        refreshProgress[repoURL] = task.progress
        task.resume()
    }

    static func packageIDSearch(id: String) -> [Package] {
        return packages.values.filter({ $0.identifier == id })
    }
    
    static func grabPackageFromRepo(id: String, for repoURL: String, ext: String, completion: @escaping (Package?) -> Void) {
        guard let url = URL(string: PackageManager.packagesURL(for: repoURL) + ext), URLFunction.valid(repoURL) else {
            completion(nil)
            return
        }

        let urlRequest = URLFunction.aptRequest(for: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { dataCompressed, response, error in
            DispatchQueue.global(qos: .utility).async {
                if let response = (response as? HTTPURLResponse)?.statusCode, response != 200 {
                    completion(nil)
                    return
                }

                guard let dataCompressed = dataCompressed else {
                    completion(nil)
                    return
                }

                var data = dataCompressed

                do {
                    data = try PackageManager.decompress(data: data, ext: ext, url: url)
                } catch {
                    log("Failed to extract data from \(url): \(error)")
                    completion(nil)
                    return
                }

                let packagesString = String(decoding: data, as: UTF8.self)
                var splited = Package.split(packagesString)

                splited = splited.filter({
                    $0.components(separatedBy: "\n").contains("Package: " + id)
                })
                
                var package = Package()
                for packageString in splited {
                    let newPackage = Package(packageString: packageString, repoURL: repoURL)
                    if newPackage.version > package.version {
                        package = newPackage
                    }
                }

                DispatchQueue.main.async {
                    cachedPackages[package.id] = package
                    completion(package)
                }
            }
        }

        task.resume()
    }
}
