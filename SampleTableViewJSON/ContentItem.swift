//
//  ContentItem.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import Foundation
import UIKit

class ContentItem {
    var blurb: String?
    var datePosted: Int?
    var url: String?
    var title: String?
    var urlImage: String?
    // auxilliary
    var dateFormatted: String?
    var image: UIImage?

    init(json: NSDictionary) {
        self.blurb = json["blurb"] as? String
        self.datePosted = json["datePosted"] as? Int
        self.url = json["url"] as? String
        self.title = json["title"] as? String
        self.urlImage = json["urlImage"] as? String

        // Convert milliseconds since 1970 to a human-readable date string
        if let datePosted = self.datePosted {
            let timeInterval = NSTimeInterval(datePosted)
            let date = NSDate(timeIntervalSince1970: timeInterval)

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle

            self.dateFormatted = dateFormatter.stringFromDate(date)
        } else {
            self.dateFormatted = ""
        }

        if let urlImage = urlImage, imageURL = NSURL(string: urlImage), imageData = NSData(contentsOfURL: imageURL) {
            self.image = UIImage(data: imageData)
        }
    }
}
