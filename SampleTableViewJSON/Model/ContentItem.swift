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
        let timeInterval = NSTimeInterval(datePublished)
        let date = NSDate(timeIntervalSince1970: timeInterval)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle

        self.dateFormatted = dateFormatter.stringFromDate(date)

        if let imageURL = NSURL(string: urlImage), imageData = NSData(contentsOfURL: imageURL) {
            self.image = UIImage(data: imageData)
        }
    }

    //private func setAuxilliaryProperties() {

    //}
}
