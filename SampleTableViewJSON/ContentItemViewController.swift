//
//  ContentItemViewController.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import UIKit

class ContentItemViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var webView: UIWebView!

    // MARK: - Properties
    var urlString: String?

    // MARK: - Initializers

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let urlString = urlString, url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
}
