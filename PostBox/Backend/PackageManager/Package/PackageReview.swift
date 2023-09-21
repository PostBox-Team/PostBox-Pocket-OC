//
//  PackageReviews.swift
//  PostBox
//
//  Created by b0kch01 on 7/28/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

extension Package {
    
    /// Mean review score of package
    var meanScore: String {
        let mean = reviews.compactMap { $0.rating.doubleGuess }
            .reduce(0, +) / Double(reviews.count)

        return String(format: "%.1f", mean)
    }
    
    /// Loads package reviews from databse
    func loadReviews(completion: (() -> Void)?=nil) {
        let packageID = identifier
        
        let database = Firestore.firestore()
        let reviews = database
            .collection("package_data")
            .document(packageID)
            .collection("reviews")
            .whereField("approved", in: [true, !Defaults.bool(forKey: "ignore-review-moderation")])
        
        reviews.getDocuments { doc, _ in
            guard let data = doc?.documents else { return }
            let newReviewData = data.compactMap { try? $0.data(as: Review.self) }
            
            DispatchQueue.main.async { [weak self] in
                self?.reviews = newReviewData.reversed()
                completion?()
            }
        }
    }
}
