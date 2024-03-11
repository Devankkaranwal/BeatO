//
//  VideoViewController.swift
//  BeatOApp
//
//  Created by Devank on 06/03/24.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var videoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
               
               if let videoURL = videoURL {
                   let request = URLRequest(url: videoURL)
                   webView.load(request)
               }
    }
    

   
}
