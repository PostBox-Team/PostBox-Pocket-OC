//
//  Double.swift
//  PostBox
//
//  Created by b0kch01 on 7/23/22.
//  Copyright © 2022 PostBoxTeam. All rights reserved.
//

import Foundation

extension Int {
    var sizeMB: String {
        "\((Double(self)/100000).rounded() / 10) MB"
    }
}
