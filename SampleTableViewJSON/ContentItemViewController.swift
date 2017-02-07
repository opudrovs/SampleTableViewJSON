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

    var viewData: ContentItemViewData?

    // MARK: - Initializers

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = WKWebView(frame: CGRect.zero, configuration: WKWebViewConfiguration())

        guard let webView = self.webView else { return }
        self.view.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webView]-0-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["webView": webView])
        self.view.addConstraints(horizontalConstraints)

        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[webView]-0-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["webView": webView])
        self.view.addConstraints(verticalConstraints)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let viewData = self.viewData else { return }
        self.updateWithViewData(viewData: viewData)
    }

    // MARK: - Private

    fileprivate func updateWithViewData(viewData: ContentItemViewData) {
        self.title = viewData.title

        guard let path = viewData.path, let url = URL(string: path) else { return }

        let request = URLRequest(url: url)
        _ = self.webView?.load(request)
    }
}
