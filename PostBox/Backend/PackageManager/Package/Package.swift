//
//  Package.swift
//  PostBox
//
//  Created by b0kch01 on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import URLImage
import FirebaseFirestore
import SWCompression
import PartialSheet
import DataCompression

/// Struct representing a debian package
class Package: ObservableObject, Identifiable, Equatable, Comparable {
    
    static func == (lhs: Package, rhs: Package) -> Bool { lhs.id == rhs.id }
    static func < (lhs: Package, rhs: Package) -> Bool { lhs.name < rhs.name }
    
    /// Creates an ID from pacpkage id and repo
    static func genID(id: String, url: String) -> String {
        let url = url.hasSuffix("/") ? String(url.dropLast(1)) : url
        return id + url
    }
    
    /// A published value that represents Sileo's Native Depiction Spec
    @Published var sileoDepiction: SileoDepiction
    /// A published value that checks if sileodepictions are successfully loaded
    @Published var sileoDepictionsLoaded = false
    /// Review Data
    @Published var reviews = [Review]()
    /// Package price
    @Published var priceNum: Double
    
    /// `Identifiable` based ID; (bundle-ID + repoURL)
    var id: String
    /// Package identified (bundle-ID)
    var identifier: String
    
    var name: String
    var description: String
    var depends: [Dependency]
    
    var maintainer: Contact
    var author: Contact

    var section: String
    var version: String
    var tags: [String]
    var icon: String
    var filename: String
    var size: String

    /// URLS
    var depiction: String
    var sileoDepictionURL: String
    var sileoEndpoint: String?
    var repoURL: String
    var repoURLNoProtocol: String { repoURL.lowercased().replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "") }

    /// Size into MB
    var sizeMB: String {
        if var bytes = Double(size) {
            bytes /= 100000
            return "\(bytes.rounded() / 10) MB"
        }
        return size
    }

    /// For the `Codable` protocol
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    // MARK: - Init Functions
    
    init(
        id: String?=nil,
        name: String?=nil,
        depends: [Dependency]?=nil,
        price: Double?=nil,
        description: String?=nil,
        maintainer: Contact?=nil,
        author: Contact?=nil,
        section: String?=nil,
        version: String?=nil,
        tags: [String]?=nil,
        icon: String?=nil,
        depiction: String?=nil,
        sileoDepictionURL: String?=nil,
        filename: String?=nil,
        size: String?=nil,
        repoURL: String?=nil
    ) {
        let repoURL = repoURL ?? "Unknown"
        self.repoURL = repoURL
        
        let id = id ?? UUID().uuidString
        self.id = Package.genID(id: id, url: repoURL)
        self.identifier = id
        
        self.name = name ?? "Package"
        self.depends = depends ?? [Dependency]()
        self.priceNum = price ?? 0
        self.description = description ?? "An awesome package!"
        self.maintainer = maintainer ?? Contact()
        self.author = author ?? Contact()
        self.section = section ?? ""
        self.version = version ?? ""
        self.tags = tags ?? [String]()
        self.icon = icon ?? ""
        self.depiction = depiction ?? ""
        self.sileoDepictionURL = sileoDepictionURL ?? ""
        self.filename = filename ?? ""
        self.size = size ?? ""
        self.sileoDepiction = SileoDepiction()
    }
    
    init(packageString: String, repoURL: String) {
        let uuid = UUID().uuidString
        let cleaned = packageString
            .replacingOccurrences(of: "\n .\n ", with: "<br><br>")
            .replacingOccurrences(of: "\n ", with: "<br>")
            .replacingOccurrences(of: "\r", with: "")
        
        var package        = uuid
        var name           = "Unknown"
        var depends        = [Dependency]()
        var description    = "An awesome package!"
        var maintainer     = Contact()
        var author         = Contact()
        var section        = ""
        var version        = ""
        var tag            = [String]()
        var icon           = ""
        var depiction      = ""
        var sileoDepiction = ""
        var filename       = ""
        var size           = ""
        
        for row in cleaned.components(separatedBy: "\n").map({ $0.components(separatedBy: ": ") }) where row.count == 2 {
            switch row.first {
            case "Package": package               = row[1, default: package].lowercased()
            case "Name": name                     = row[1, default: name]
            case "Depends": depends               = row[1, default: ""].components(separatedBy: ", ").map { Dependency($0) }
            case "Description": description       = row[1, default: description]
            case "Maintainer": maintainer         = Contact(row[1, default: ""])
            case "Author": author                 = Contact(row[1, default: ""])
            case "Section": section               = row[1, default: section]
            case "Version": version               = row[1, default: version]
            case "Tag": tag                       = row[1, default: ""].components(separatedBy: ", ")
            case "Icon": icon                     = row[1, default: icon]
            case "Depiction": depiction           = row[1, default: depiction]
            case "SileoDepiction",
                 "Sileodepiction": sileoDepiction = row[1, default: sileoDepiction]
            case "Filename": filename             = row[1, default: filename]
            case "Size": size                     = row[1, default: size]
            default: break
            }
        }
        
        self.identifier        = package
        self.id                = Package.genID(id: package, url: repoURL)
        self.repoURL           = repoURL
        self.priceNum          = -1
        self.sileoDepiction    = SileoDepiction()
        self.sileoDepictionURL = sileoDepiction
        self.name              = name == "Unknown" ? (package == uuid ? "Unknown" : package) : name
        self.depends           = depends
        self.description       = description
        self.maintainer        = maintainer
        self.author            = author
        self.section           = section
        self.version           = version
        self.tags              = tag
        self.icon              = icon
        self.depiction         = depiction
        self.filename          = filename
        self.size              = size
    }
    
    // MARK: - Merge data
    
    func merge(with package: Package, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.identifier        = package.identifier
            self.id                = package.id
            self.repoURL           = package.repoURL
            self.priceNum          = package.priceNum
            self.sileoDepiction    = package.sileoDepiction
            self.sileoDepictionURL = package.sileoDepictionURL
            self.name              = package.name
            self.depends           = package.depends
            self.description       = package.description
            self.maintainer        = package.maintainer
            self.author            = package.author
            self.section           = package.section
            self.version           = package.version
            self.tags              = package.tags
            self.icon              = package.icon
            self.depiction         = package.depiction
            self.filename          = package.filename
            self.size              = package.size
            
            completion?()
        }
    }
}
