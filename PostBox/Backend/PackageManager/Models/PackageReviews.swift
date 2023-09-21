//
//  PackageReviews.swift
//  PostBox
//
//  Created by b0kch01 on 3/4/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import FirebaseFirestoreSwift

enum ReviewSortType: String {
    case recent
    case favorable
    case critical
}

struct Review: Codable, Identifiable {
    
    static func sort(with sortType: ReviewSortType, lhs: Review, rhs: Review) -> Bool {
        switch sortType {
        case .recent: return lhs.id ?? "" > rhs.id ?? ""
        case .favorable: return lhs.rating > rhs.rating
        case .critical: return lhs.rating < rhs.rating
        }
    }
    
    @DocumentID public var id: String?
    
    var time: Date
    var body: String
    var author: String
    var rating: FlexibleString
    var approved: FlexibleString
}
