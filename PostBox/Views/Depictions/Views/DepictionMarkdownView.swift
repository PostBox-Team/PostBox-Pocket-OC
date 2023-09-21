//
//  DepictionMarkdownView.swift
//  PostBox
//
//  Created by b0kch01 on 11/15/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI
import Down
import UIKit
import WebKit

struct DepictionMarkdownView: View {
    
    @State var height = CGFloat.zero
    
    var speedyRender = false
    
    var html: String
    var string: NSAttributedString
    let background: String?
    
    private func useAttributedString(_ markdown: String, force forceSlow: Bool) -> Bool {
        if forceSlow { return false }
        
        // Check for stuff not handleable by attributed string
        let cannotHave = ["](", "href=", "<iframe", "<img"]
        for value in cannotHave where markdown.contains(value) { return false }
        
        return true
    }
    
    private let htmlStart = ("""
<HTML>
    <HEAD>
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no, maximum-scale=1.0, user-scalable=no\">
        <style>
            * { box-sizing: border-box; }

            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
                padding: 0;
                margin: 0;
                line-height: 150%;
                overflow-wrap: break-word;
                overflow-y: hidden;
            }

            li::marker {
                color: $accentcolor$;
            }

            iframe {
                margin: 0 auto;
                width: 80%;
                border: solid 1px lightgray;
                border-radius: 5px;
            }

            img {
                width: 100%;
            }

            code {
                font-family: "SFMono-Regular", Consolas, Menlo, monospace;
                color: #EB5757;
                font-size: 90%;
                padding: 0.2em 0.4em;
                background: rgba(135, 131, 120, 0.15);
                border-radius: 3px;
            }

            img {
                max-width: 100%;
                object-fit: contain;
            }

            hr {
                border: 0;
                height: 0.2px;
                background: lightgray;
            }

            a {
                color: #8E8E93;
                text-decoration: underline;
            }

            @media (prefers-color-scheme: dark) {
                body {
                    color: #FFF;
                }

                a {
                    color: #8E8E93;
                }
            }
        </style>
    </HEAD>
    <BODY>
""")
    private let htmlEnd = "</BODY></HTML>"
    
    init(data: DepictionObjectView, color: String) {
        self.background = data.backgroundColor
        self.html = ""
        self.string = NSAttributedString(string: " ")
        
        let forceSlow = !Defaults.bool(forKey: "setting-enable-fast-depicts")
        
        let color = data.tintColor ?? color
        
        if let markdown = data.markdown {
            if forceSlow || data.useRawFormat?.boolValue == true || markdown.contains("](") {
                let markdownTrimmed = markdown.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let rendered = try? Down(markdownString: markdownTrimmed).toHTML(.smartUnsafe) else {
                    self.html = "\(htmlStart.replacingOccurrences(of: "$accentcolor$", with: color))\(markdown)\(htmlEnd)"
                    return
                }
                
                let cleanRendered = rendered
                    .replacingOccurrences(of: "<p>&amp;nbsp;</p>", with: "<p></p>")
                    .replacingOccurrences(of: "$accentcolor$", with: color)
                    .replacingOccurrences(of: "background:red", with: "") // Chariz.........why....???
                
                self.html = "\(htmlStart)\(cleanRendered)\(htmlEnd)"
                
                if useAttributedString(markdown, force: forceSlow) {
                    self.speedyRender = true
                    self.html = html.replacingOccurrences(of: "/*FONTSIZE*/", with: "font-size: 12pt;")
                    return
                }
            } else {
                self.speedyRender = true
                
                let down = Down(markdownString: markdown)
                
                let downStylerObject = DownStyler(
                    configuration: DownStylerConfiguration(
                        fonts: DepictionFonts(),
                        colors: StaticColorCollection(
                            heading1: .label,
                            heading2: .label,
                            heading3: .label,
                            heading4: .label,
                            heading5: .label,
                            heading6: .label,
                            body: .label,
                            code: Color.primary.uiColor(),
                            link: hexStringToUIColor(hex: color),
                            listItemPrefix: hexStringToUIColor(hex: color),
                            codeBlockBackground: .secondarySystemBackground
                        )
                    )
                )
                
                guard let attributed = try? down.toAttributedString(styler: downStylerObject) else { return }

                self.string = attributed
            }
        }
    }
    
    @ViewBuilder
    var body: some View {
        if speedyRender {
            GeometryReader { geo in
                DepictionMarkdownViewFast(height: $height, width: geo.size.width, string: string, html: html)
            }
            .padding(.horizontal, UIConstants.margin)
            .frame(height: height)
        } else {
            DepictionMarkdownWebView(contentHeight: $height, html: html)
                .padding(.horizontal, UIConstants.margin)
                .frame(height: height)
                .background(background == nil ? Color.white.opacity(0) : Color(background!))
        }
    }
}

struct DepictionMarkdownViewFast: UIViewRepresentable {
    
    @Binding var height: CGFloat
    
    var width: CGFloat
    
    let string: NSAttributedString
    let html: String
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        label.preferredMaxLayoutWidth = width
        
        return label
    }
    
    func updateUIView(_ label: UILabel, context: Context) {
        DispatchQueue.global(qos: .userInitiated).async {
            if html.count != 0 {
                if let attributedString = try? NSMutableAttributedString(data: html.data(using: .unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    attributedString.removeAttribute(NSAttributedString.Key("NSOriginalFont"), range: NSRange(location: 0, length: attributedString.length))
                    attributedString.enumerateAttribute(.foregroundColor, in: NSRange(0..<attributedString.length), options: .longestEffectiveRangeNotRequired) { attribute, range, _ in
                        if let color = attribute as? UIColor, color == UIColor(cgColor: CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)) {
                            attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: range)
                        }
                    }

                    DispatchQueue.main.async {
                        let newHeight = attributedString.height(containerWidth: width)
                        height = newHeight
                        label.attributedText = attributedString
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let newHeight = string.height(containerWidth: width)
                    height = newHeight
                    label.attributedText = string
                }
            }
        }
    }
}
struct DepictionMarkdownWebView: UIViewRepresentable {
    
    @Binding var contentHeight: CGFloat
    
    var webview: WKWebView = WKWebViewWarmUper.shared.dequeue()
    var html: String

    func makeUIView(context: Context) -> WKWebView {
        webview.navigationDelegate = context.coordinator
        webview.scrollView.bounces = false
        webview.scrollView.backgroundColor = .clear
        webview.backgroundColor = .clear
        webview.isOpaque = false
        webview.loadHTMLString(html, baseURL: nil)
        
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: DepictionMarkdownWebView

        init(_ parent: DepictionMarkdownWebView) { self.parent = parent }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { height, _ in
                DispatchQueue.main.async { [weak self] in
                    if let height = height as? CGFloat {
                        self?.parent.contentHeight = height
                    }
                }
            })
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated {
                guard let url = navigationAction.request.url else {
                    return decisionHandler(.allow)
                }
                
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                if components?.scheme == "http" || components?.scheme == "https" {
                    UIApplication.shared.open(url)
                    return decisionHandler(.cancel)
                }
            }
            decisionHandler(.allow)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }
}
