//
//  WebViewController.swift
//  VideoIt
//
//  Created by swati on 27/06/24.
//

import UIKit
import WebKit

class WebViewController: BaseVC {

    @IBOutlet weak var webView: WKWebView!
    var url: String = ""
    var screenTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        title = screenTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func loadWebView() {
        // Specify the URL to load
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
