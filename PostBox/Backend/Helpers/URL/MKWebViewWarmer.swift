//
//  Created by Timur Bernikovich on 07/03/2019.
//  Copyright © 2019 Timur Bernikovich. All rights reserved.
//

import WebKit
import SwiftUI
import SafariServices
import UIKit

protocol WarmUpable {
    func warmUp()
}

class WarmUper<Object: WarmUpable> {
    
    private let creationClosure: () -> Object
    private var warmedUpObjects: [Object] = []
    var numberOfWamedUpObjects: Int = 5 {
        didSet {
            prepare()
        }
    }
    
    init(creationClosure: @escaping () -> Object) {
        self.creationClosure = creationClosure
        prepare()
    }
    
    func prepare() {
        while warmedUpObjects.count < numberOfWamedUpObjects {
            let object = creationClosure()
            object.warmUp()
            warmedUpObjects.append(object)
        }
    }
    
    private func createObjectAndWarmUp() -> Object {
        let object = creationClosure()
        object.warmUp()
        return object
    }
    
    func dequeue() -> Object {
        let warmedUpObject: Object
        if let object = warmedUpObjects.first {
            warmedUpObjects.removeFirst()
            warmedUpObject = object
        } else {
            warmedUpObject = createObjectAndWarmUp()
        }
        prepare()
        return warmedUpObject
    }
    
}

extension WKWebView: WarmUpable {
    func warmUp() {
        loadHTMLString("", baseURL: nil)
    }
}

typealias WKWebViewWarmUper = WarmUper<WKWebView>
extension WarmUper where Object == WKWebView {
    static let shared = WKWebViewWarmUper(creationClosure: {
        WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    })
}

/// SFSafariViewController for SwiftUI
struct NaiveSafariView: UIViewControllerRepresentable {
    
    var url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let sfvc = SFSafariViewController(
            url: url,
            configuration: SFSafariViewController.Configuration(barCollapsingEnabled: false)
        )
        
        sfvc.preferredControlTintColor = UIConstants.UITint

        return sfvc
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
