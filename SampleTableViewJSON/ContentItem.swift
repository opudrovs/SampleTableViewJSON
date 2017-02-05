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
    var path: String
    var title: String
    var datePublished: Int
    var imageURL: String
    var dateFormatted: String
    var image: UIImage?

    init(blurb: String, path: String, title: String, datePublished: Int, imageURL: String) {
        self.blurb = blurb
        self.path = path
        self.title = title
        self.datePublished = datePublished
        self.imageURL = imageURL

        // Convert milliseconds since 1970 to a human-readable date string
        let timeInterval = TimeInterval(datePublished)
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        self.dateFormatted = dateFormatter.string(from: date)

        guard let imageURL = URL(string: imageURL), let imageData = try? Data(contentsOf: imageURL) else { return }

        self.image = UIImage(data: imageData)
    }
}
