//
//  ContentView.swift
//  PostBox
//
//  Created by b0kch01 on 11/8/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import URLImage
import UIKit
import PartialSheet

struct ContentView: View {
    
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var bubbleController: BubbleController
    @EnvironmentObject var packageManager: PackageManager
    @EnvironmentObject var repoManager: RepoManager
    
    @State var showingLog = false
    @State var selected: Int?
        
    @ObservedObject var color = uiConstants
    
    let sheetStyle = PartialSheetStyle(
        background: .solid(Color.primaryBackground),
        handlerBarStyle: .none,
        iPadCloseButtonColor: Color(UIColor.systemGray2),
        enableCover: true,
        coverColor: Color.partialSheetBackground,
        blurEffectStyle: nil,
        cornerRadius: 10,
        minTopDistance: 10
    )
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIConstants.UITint
        
        URLImageService.shared.defaultOptions.loadOptions.formUnion(.loadImmediately)
        URLImageService.shared.defaultOptions.cachePolicy = .returnCacheElseLoad()
        URLImageService.shared.defaultOptions.maxPixelSize = CGSize(width: 4096, height: 4096)
        WKWebViewWarmUper.shared.prepare()
        
        // Navigation Bar styling
        UINavigationBar.appearance().barTintColor = UIColor.systemBackground
        UINavigationBar.appearance().shadowImage = UIImage.imageWithColor(color: .tertiarySystemFill)
        
        // List View styling
        UITableView.appearance().backgroundColor = .clear
        
        // TextEditor styling
        UITextView.appearance().backgroundColor = .clear
    }
    
    @ViewBuilder
    var homeModal: some View {
        NavigationView {
            Group {
                switch sceneManager.root {
                case "package":
                    PackageView(
                        PackageManager.packageIDSearch(id: sceneManager.content)[0, default: Package(id: sceneManager.content)],
                        inModal: true
                    )
                    .environmentObject(packageManager)
                    .environmentObject(repoManager)
                case "repo":
                    BrowseRepo(
                        repoManager.repos[sceneManager.content] ?? Repo(url: sceneManager.content)
                    )
                    .environmentObject(packageManager)
                    .environmentObject(repoManager)
                default:
                    Text("Invalid URL")
                }
            }
        } // TODO: Fix homeModal showing up at launch
    }
    
    @ViewBuilder
    var body: some View {
        Group {
            if #available(iOS 15, *) {
                HomeViewiOS15()
            } else {
                HomeView()
            }
        }
        .accentColor(Color.primary)
        .navigationViewStyle(StackNavigationViewStyle())
        .addPartialSheet(style: sheetStyle)
        .sheet(isPresented: $sceneManager.present) { homeModal }
        .overlay(
            ZStack(alignment: .top) {
                ForEach(bubbleController.bubbles) { bubbleData in
                    Button(action: { showingLog = true }) {
                        Bubble(bubbleData)
                    }
                    .buttonStyle(CardButtonStyle())
                }
            }
            ,
            alignment: .top
        )
    }
}
