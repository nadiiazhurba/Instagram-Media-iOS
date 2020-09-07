//
//  WebView.swift
//  InstagramMedia
//
//  Created by Надежда Журба on 03.09.2020.
//  Copyright © 2020 NadiiaZhurba. All rights reserved.
//

import SwiftUI
import WebKit
struct WebViewController: UIViewRepresentable {
  //MARK:- Member variables
    @Binding var presentAuth: Bool
    @Binding var testUserData: InstagramTestUser
    @Binding var instagramApi: InstagramApi
    
    //MARK:- UIViewRepresentable Delegate Methods
    func makeCoordinator() -> WebViewController.Coordinator {
      return Coordinator(parent: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<WebViewController>) -> WKWebView {
      let webView = WKWebView()
      webView.navigationDelegate = context.coordinator
      return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebViewController>) {
      instagramApi.authorizeApp { (url) in
        DispatchQueue.main.async {
          webView.load(URLRequest(url: url!))
        }
      }
    }
    
    //MARK:- Coordinator class
    class Coordinator: NSObject, WKNavigationDelegate {
      var parent: WebViewController
        
      init(parent: WebViewController) {
      self.parent = parent
      }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
          let request = navigationAction.request
          self.parent.instagramApi.getTestUserIDAndToken(request: request) { (instagramTestUser) in
          self.parent.testUserData = instagramTestUser
          self.parent.presentAuth = false
          }
          decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
}
