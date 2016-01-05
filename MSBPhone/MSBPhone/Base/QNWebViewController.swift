//
//  QNWebViewController.swift
//  QooccShow
//
//  Created by LiuYu on 14/12/16.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

import UIKit


/**
*  普通的网页浏览
*/
class QNWebViewController : UIViewController, UIWebViewDelegate, QNInterceptorProtocol {
    var url: String = "";
    var webView: UIWebView?;
    var activity: UIActivityIndicatorView?;
    
    convenience init(url: String) {
        self.init()
        self.url = url
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 内容显示在WebView上
        self.webView = UIWebView(frame:self.view.bounds)
        self.webView!.backgroundColor = UIColor(white: 229/255.0, alpha: 1.0)
        self.webView!.opaque = false
        self.webView!.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleBottomMargin, .FlexibleWidth, .FlexibleHeight];
        self.webView!.delegate = self;
        self.view.addSubview(self.webView!)
        
        // 开启旋转提示框
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.activity!.center = self.webView!.center;
        self.view.addSubview(self.activity!)
        
        self.activity!.startAnimating()
        
        // 加载URL
        self.webView!.loadRequest(NSURLRequest(URL: NSURL(string: self.url)!))
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.webView?.delegate = nil;
        self.webView?.stopLoading()
        self.webView?.removeFromSuperview()
        self.webView = nil;
        
        self.activity?.removeFromSuperview()
        self.activity = nil
    }
    
    //MARK:- UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activity?.stopAnimating()
    }
    
}