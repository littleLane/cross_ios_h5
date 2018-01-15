//
//  ViewController.swift
//  webViewWithJS
//
//  Created by tangshimi on 09/12/2017.
//  Copyright © 2017 guahao. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  let url = Bundle.main.url(forResource: "index", withExtension: "html")
        
        let url = URL.init(string: "http://169.254.32.97:8090/aaa/index.html")
        
        webView.load(URLRequest.init(url: url!))
        view.addSubview(webView)
    }

    private lazy var webView: WKWebView = {
        let configuretion = WKWebViewConfiguration()
        configuretion.preferences = WKPreferences()
        configuretion.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // 通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        // window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
        configuretion.userContentController.add(self, name: "weDoctorApp")
        configuretion.userContentController.add(self, name: "doctorApp")

        let view = WKWebView.init(frame: self.view.bounds, configuration:  configuretion)
        return view
    }()
}

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "weDoctorApp" {
            let body = message.body as? String
            
            guard let body1 = body, let url = URL(string: body1) else {
                let js = "callHtml(\"打开\",\"失败\")"
                self.webView.evaluateJavaScript(js, completionHandler: { (_, _) in
                    
                })
                return
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                if success {
                    let js = "callHtml(\"打开\",\"成功\")"
                    self.webView.evaluateJavaScript(js, completionHandler: { (_, _) in
                            
                    })
                } else {
                    let js = "callHtml(\"打开\",\"失败\")"
                    self.webView.evaluateJavaScript(js, completionHandler: { (_, _) in
                            
                    })
                }
            })
        }
    }
}
