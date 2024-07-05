//
//  WebkitVC.swift
//  CoreDemo
//
//  Created by Rishabh Jaiswal on 22/06/22.

import UIKit
import WebKit
class WebkitVC: UIViewController {
    var requestUrl:NSMutableURLRequest?
    @IBOutlet weak var webView:WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

       loadRequestWithUrl()
    }
    

    
    func loadRequestWithUrl(){
        if let request  = requestUrl{
            webView.load(request as URLRequest)
        }
        
    }
    
}
