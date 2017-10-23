//
//  MeshController.swift
//  mesh-ios
//
//  Created by Joe Osburn on 10/22/17.
//  Copyright © 2017 Mesh. All rights reserved.
//

import WebKit

class MeshController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    var appWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "mesh")
        
        let appHTMLPath = Bundle.main.path(forResource: "app", ofType: "html")
        appWebView = WKWebView(frame: view.frame, configuration: config)
        appWebView!.navigationDelegate = self
        
        appWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let url = URL(fileURLWithPath: appHTMLPath!)
        let request = URLRequest(url: url)
        
        appWebView!.load(request)
        
        view.addSubview(appWebView!)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let sentData = message.body as! NSDictionary
        
        let controller = sentData["controller"] as! String
        let action = sentData["action"] as! String
        let arguments = sentData["arguments"] as! Array<Any>
        
        if Controllers.manager.has(controller, action) {
            Controllers.manager.run(controller, action, with: arguments)
        }
        
        if let callback = sentData["callback"] as? Int {
            MeshManager.sharedManager.callback(callback)
        }
    }
    
    func sendResponse(aResponse: Dictionary<String,AnyObject>, callback: String?) {
        guard let callbackString = callback else {
            return
        }
        
        guard let generatedJSONData = try? JSONSerialization.data(withJSONObject: aResponse, options: JSONSerialization.WritingOptions(rawValue: 0)) else {
            print("failed to generate JSON for \(aResponse)")
            return
        }
        
        appWebView!.evaluateJavaScript("\(callbackString), \(NSString(data:generatedJSONData, encoding:String.Encoding.utf8.rawValue)!))")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MeshManager.sharedManager.emit("ready")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
