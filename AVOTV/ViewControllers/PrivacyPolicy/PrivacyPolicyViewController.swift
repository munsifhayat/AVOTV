//
//  PrivacyPolicyViewController.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 26/06/2021.
//

import UIKit
import WebKit

enum WebViewType:Int {
    case privacy, terms, aboutus
}

class PrivacyPolicyViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var pageType:WebViewType = .privacy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorNavBar(color: UIColor(named: "primary_white")!, navBgColor: UIColor.black)
        addBackButtonToNavBar(color: UIColor(named: "primary_white")!)
                
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.isMultipleTouchEnabled = false
        
        switch pageType {
        
        case .privacy:
            title = "Privacy Policy"
//            let url = NSURL(string: Route.privayPolicy.url())
//            webView!.load(NSURLRequest(url:url! as URL) as URLRequest)
            getPrivacyPolicyAPICall()

        case .terms:
            title = "Terms of Service"
//            let url = NSURL(string: Route.termsCondition.url())
//            webView!.load(NSURLRequest(url:url! as URL) as URLRequest)
            getTermsConditionAPICall()
            
        case .aboutus:
            title = "About US"
//            let url = NSURL(string: Route.aboutUS.url())
//            webView!.load(NSURLRequest(url:url! as URL) as URLRequest)
            getAboutUSAPICall()
        }
        
    }

}

extension PrivacyPolicyViewController: WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stopLoading()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        startLoading()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let host = navigationAction.request.url?.host, host.contains("www.nhs.uk") {
            decisionHandler(.allow)
//        }
//        else {
//            decisionHandler(.cancel)
//        }
    }
}


// Web API's Calling

extension PrivacyPolicyViewController{
    
 
    func getPrivacyPolicyAPICall() {
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            self.stopLoading()
            if let htmlString  = response["data"] as? String {
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            }
        }
        
        let failureBlock:DefaultAPIFailureClosure = { error in
            self.stopLoading()
            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        let url = Route.privayPolicy.url()
        
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
    
    func getTermsConditionAPICall(){
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            self.stopLoading()
            if let htmlString  = response["data"] as? String {
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            }
        }
        
        let failureBlock:DefaultAPIFailureClosure = { error in
            self.stopLoading()
            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        let url = Route.termsCondition.url()
        
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
    
    func getAboutUSAPICall() {
        
        startLoading()
        
        let successBlock:DefaultAPISuccessClosure = { response in
            self.stopLoading()
            if let htmlString  = response["data"] as? String {
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            }
        }
        
        let failureBlock:DefaultAPIFailureClosure = { error in
            self.stopLoading()
            Utility.showAlert(title: "Error", message: error.localizedDescription)
        }
        
        let url = Route.aboutUS.url()
        
        APIHandler.instance.getRequest(route: url, parameters: [:], success: successBlock, failure: failureBlock, errorPopup: true)
    }
}
