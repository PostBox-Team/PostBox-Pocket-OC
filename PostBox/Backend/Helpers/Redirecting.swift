//
//  Redirecting.swift
//  PostBox
//
//  Created by b0kch01 on 12/5/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

// Alerts will have a box color
extension UIAlertController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.tintColor = UIConstants.UITint
    }
}
