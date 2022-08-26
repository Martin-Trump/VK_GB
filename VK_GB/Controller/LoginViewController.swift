//
//  LoginViewController.swift
//  VK_GB
//
//  Created by Павел Шатунов on 01.08.2022.
//

import Foundation
import UIKit
import WebKit

class LoginViewController: UIViewController {
   
    private lazy var vkWebView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.frame = self.view.bounds
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(vkWebView)
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
                    url.path == "/blank.html",
                    let fragment = url.fragment else {
                        decisionHandler(.allow)
                        return
        }
        
        let params = fragment
                    .components(separatedBy: "&")
                    .map { $0.components(separatedBy: "=") }
                    .reduce ([String:String]()) { result, param in
                        var dict = result
                        let key = param[0]
                        let value = param[1]
                        dict[key] = value
                        return dict
                        
        }
        
        let token = params["access_token"]
        let userID = params["user_id"]
        Session.shared.userId = Int(userID!)
        Session.shared.token = token!
        
        if token != nil {
            let mainMenu = MainMenuViewController()
            mainMenu.modalPresentationStyle = .fullScreen
            self.present(mainMenu, animated: true, completion: nil)
        }
        
        decisionHandler(.cancel)
    }
}
