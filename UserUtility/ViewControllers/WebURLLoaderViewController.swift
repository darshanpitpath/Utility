//
//  WebURLLoaderViewController.swift
//  UserUtility
//
//  Created by IPS on 12/10/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit
import WebKit

class WebURLLoaderViewController: UIViewController {

    @IBOutlet weak var objWebView:WKWebView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var buttonClose:UIButton!
    
    var objURLString = "https://lisaslaw.co.uk/#contact_us"
    override func viewDidLoad() {
        super.viewDidLoad()

        //load WebView
        self.loadWebViewWith(url: URL.init(string: "\(objURLString)")!)
    }
    // MARK: - Custom Methods
    func loadWebViewWith(url:URL){
        DispatchQueue.main.async {
            ShowHud.show()
        }
        objWebView.navigationDelegate = self
        objWebView.load(URLRequest.init(url: url))
        objWebView.allowsBackForwardNavigationGestures = true
    }
    // MARK: - Selector Methods
    @IBAction func buttonCloseSelector(sender:UIButton){
        //Dismiss ViewController
        self.dismiss(animated: true , completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension WebURLLoaderViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.async {
            ShowHud.show()
        }
        print("didCommit navigation:")
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            ShowHud.show()
        }
        print("didStartProvisionalNavigation navigation:")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            ShowHud.hide()
         }
        print("didFinish navigation:")
    }
   
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            ShowHud.hide()
        }
        print(" didFail navigation:")
    }
}
