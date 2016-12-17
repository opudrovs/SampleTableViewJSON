//
//  ContentItemViewController.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import UIKit
import WebKit

class ContentItemViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var webView: WKWebView?

    // MARK: - Properties
    var urlString: String?

    // MARK: - Initializers

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let userContentController = WKUserContentController()
//        userContentController.addUserScript(deviceScript)
//        userContentController.addUserScript(userScript)
//        userContentController.add(handler, name: "heightObserver")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        self.webView = WKWebView(frame: CGRect.zero, configuration: configuration)

        let webView = self.webView!
        self.view.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)

        self.view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        let request = URLRequest(url: url)
        webView?.load(request)
    }
}
