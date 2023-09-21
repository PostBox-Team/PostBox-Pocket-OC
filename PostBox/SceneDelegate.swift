//
//  SceneDelegate.swift
//  PostBox
//
//  Created by b0kch01 on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import UIKit
import SwiftUI
import Foundation
import PartialSheet

/// Globally accessible
let partialSheetManager = PartialSheetManager()
let sceneManager = SceneManager()
let bubbleManager = BubbleController()
let uiConstants = UIConstants()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func deepLink(_ url: URL?) {
        if Defaults.bool(forKey: "welcomed") {
            guard let url = url else { return }
            sceneManager.action = url.absoluteString.replacingOccurrences(of: "postbox://", with: "")
        } else {
            sceneManager.action = "splash"
            sceneManager.present = true
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if !Defaults.bool(forKey: "launched") {
            Defaults.set(true, forKey: "launched")
        }

        if connectionOptions.urlContexts.first?.url != nil {
            let url = connectionOptions.urlContexts.first?.url
            deepLink(url)
        } else {
            if !Defaults.bool(forKey: "welcomed") {
                //sceneManager.action = "splash"
                //sceneManager.present = true
                SettingsManager.restoreAll()
            }
        }

        let bannerManager = BannerManager()
        let packageManager = PackageManager()
        let repoManager = RepoManager(packageManager: packageManager)
        
        let contentView = ContentView()
            .environmentObject(sceneManager)
            .environmentObject(bubbleManager)
            .environmentObject(packageManager)
            .environmentObject(repoManager)
            .environmentObject(partialSheetManager)
            .environmentObject(bannerManager)
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
        // PostBox Startup Tasks
        bannerManager.checkForNewVersion()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        deepLink(url)
        sceneManager.present = true
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
