//
//  ContentItem.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import Foundation
import UIKit

struct ContentItem {
    var blurb: String
    var url: String
    var title: String
    var datePublished: Int
    var urlImage: String
    // auxilliary
    var dateFormatted: String
    var image: UIImage?

    init(blurb: String, url: String, title: String, datePublished: Int, urlImage: String) {
        self.blurb = blurb
        self.url = url
        self.title = title
        self.datePublished = datePublished
        self.urlImage = urlImage

        // Convert milliseconds since 1970 to a human-readable date string
        let timeInterval = TimeInterval(datePublished)
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium

        self.dateFormatted = dateFormatter.string(from: date)

        if let imageURL = URL(string: urlImage), let imageData = try? Data(contentsOf: imageURL) {
            self.image = UIImage(data: imageData)
        }
    }
}
