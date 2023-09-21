//
//  PackageManagerDownloader.swift
//  PostBox
//
//  Created by b0kch01 on 7/27/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI
import SWCompression
import DataCompression
import PartialSheet

extension PackageManager {
    // MARK: - Downloading & Extracting Debs
    
    /// Fetches download link of a package
    /// - Returns: URL to download the package
    func downloadDeb(package: Package, completion: ((String) -> Void)?=nil) {
        log("🏁 Downloading \(package.identifier)")
        guard let sileoEndpoint = package.sileoEndpoint else {
            completion?(URLFunction.join(package.repoURL, package.filename))
            return
        }
        
        let authURLStr = URLFunction.join(sileoEndpoint, "package/\(package.identifier)/authorize_download")
        guard let authorizeURL = URL(string: authURLStr) else { return }
        
        let data: [String: Any] = [
            "token": LazyImplementationOfStore.tokens[package.repoURL] ?? "",
            "udid": Device.udid,
            "device": Device.model(),
            "version": package.version,
            "repo": package.repoURL
        ]
        
        var request = URLRequest(url: authorizeURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        
        let repoURL = package.repoURL
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            guard let response = try? JSONDecoder().decode(Download.self, from: data) else { return }
            
            DispatchQueue.main.async {
                if let error = response.error {
                    log("❌ Couldn't download deb:", error, request)
                    
                    partialSheetManager.closePartialSheet()
                    
                    if LazyImplementationOfStore.tokens[repoURL] == nil {
                        bubbleManager.show(
                            BData(top: "Download Failed L", bottom: "Not logged in L", icon: "xmark.circle.fill", color: .yellow)
                        )
                    } else {
                        bubbleManager.show(
                            BData(top: "Download Failed L", bottom: "Not purchased L", icon: "xmark.circle.fill", color: .red)
                        )
                    }
                    
                    return
                }
                
                if let url = response.url {
                    DispatchQueue.main.async {
                        log("✅ Sending user to download the deb through url:", url)
                        completion?(url)
                    }
                    return
                }
            }
        }
        .resume()
    }
    
    /// Download .deb, extract it, and open it in Files
    func fetchExtractDeb(package: Package, downloadLink: String, completion: ((Bool, URL?) -> Void)?=nil) -> Progress? {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let base =  doc.appendingPathComponent(package.identifier)
        let tarPath = base.appendingPathComponent("Click me once.tar")
        
        guard let url = URL(string: downloadLink) else {
            completion?(false, nil)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: URLFunction.aptRequest(for: url)) { data, _, error in
            DispatchQueue.global(qos: .utility).async {
                guard let data = data else {
                    log("❌ Couldn't download file: \(String(describing: error))")
                    completion?(false, nil)
                    return
                }
                
                do {
                    log("📦 Extracting .deb file of size \(data.count.sizeMB)...")
                    guard let tarGz = try ArContainer.open(container: data).last else {
                        log("❌ Couldn't get file; didn't exist")
                        completion?(false, nil)
                        return
                    }
                    
                    log("📦 Unzipping tar of size \(tarGz.info.size?.sizeMB ?? "XX MB")...")
                    log("⏳ Be patient, this can take a while...")
                    guard let tarGzData = tarGz.data else {
                        log("❌ Couldn't get data from archive; didn't exist or empty")
                        completion?(false, nil)
                        return
                    }
                    
                    let fileName = tarGz.info.name
                    var tar: Data?
                    
                    if fileName.contains(".lzma2") {
                        log("-- found .lzma2")
                        tar = try LZMA2.decompress(data: tarGzData)
                    } else if fileName.contains(".lzma") {
                        log("-- found .lzma \(fileName)")
                        guard let decompressed = tarGzData.decompress(withAlgorithm: .lzma) else {
                            throw DeflateError.symbolNotFound
                        }
                        tar = decompressed
                    } else if fileName.contains(".bz2") {
                        log("-- found .bz2")
                        tar = try BZipCompression.decompressedData(with: tarGzData)
                    } else if fileName.contains(".xz") {
                        log("-- found .xz")
                        tar = try XZArchive.unarchive(archive: tarGzData)
                    } else if fileName.contains(".gz") {
                        log("-- found .gz")
                        tar = try GzipArchive.unarchive(archive: tarGzData)
                    } else {
                        log("⚠️ Unidentifiable compression method: \(fileName) ")
                        completion?(false, nil)
                        return
                    }
                    
                    log("💾 Done unzipping--saving file")
                    try FileManager().createDirectory(at: base, withIntermediateDirectories: true)
                    try tar?.write(to: tarPath)
                    completion?(true, base)
                } catch {
                    completion?(false, nil)
                    log("❌ Coudln't use .deb: \(error)")
                }
            }
        }
        
        if !workingPackages.contains(package) {
            workingPackages.append(package)
        }
        
        task.resume()
        return task.progress
    }
}
