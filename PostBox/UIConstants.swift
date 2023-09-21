//
//  UIConstants.swift
//  PostBox
//
//  Created by Polarizz on 3/31/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import UIKit

class UIConstants: ObservableObject {
    static var margin: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if [
                "iPhone8,1",
                "iPhone8,4",
                "iPhone9,1",
                "iPhone9,3",
                "iPhone10,1",
                "iPhone10,4",
                "iPhone11,8",
                "iPhone12,1",
                "iPhone12,8",
                "iPod9,1"
            ]
            .contains(Device.model()) {
                return 20
            }

            return 16
        } else {
            return 20
        }
    }
    
    static var tint: Color {
        return .accentColor
    }
    
    static var UITint: UIColor {
        return Color.accentColor.uiColor()
    }
    
    @Published var dynamicColor = Defaults.color(forKey: "app-color")
    
    // Symbol Fonts
    static var title2: CGFloat {
        if #available(iOS 15, *) {
            return Types.title2 - 5 as CGFloat
        } else {
            return Types.title2 as CGFloat
        }
    }
    
    static var title3: CGFloat {
        if #available(iOS 15, *) {
            return Types.title3 - 3 as CGFloat
        } else {
            return Types.title3 as CGFloat
        }
    }
    
    static var callout: CGFloat {
        if #available(iOS 15, *) {
            return Types.callout - 3 as CGFloat
        } else {
            return Types.callout as CGFloat
        }
    }
    
    static var subheadline: CGFloat {
        if #available(iOS 15, *) {
            return Types.subheadline - 3 as CGFloat
        } else {
            return Types.subheadline as CGFloat
        }
    }
    
    static var footnote: CGFloat {
        if #available(iOS 15, *) {
            return Types.footnote - 3 as CGFloat
        } else {
            return Types.footnote as CGFloat
        }
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension ScrollView {
    public func fixFlickering() -> some View {
        return self.fixFlickering { (scrollView) in
            return scrollView
        }
    }
    
    public func fixFlickering<T: View>(@ViewBuilder configurator: @escaping (ScrollView<AnyView>) -> T) -> some View {
        GeometryReader { geometryWithSafeArea in
            GeometryReader { _ in
                configurator(
                    ScrollView<AnyView>(self.axes, showsIndicators: self.showsIndicators) {
                        AnyView(
                            VStack {
                                self.content
                            }
                            .padding(.top, geometryWithSafeArea.safeAreaInsets.top)
                            .padding(.bottom, geometryWithSafeArea.safeAreaInsets.bottom)
                            .padding(.leading, geometryWithSafeArea.safeAreaInsets.leading)
                            .padding(.trailing, geometryWithSafeArea.safeAreaInsets.trailing)
                        )
                    }
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
