//
//  FeedTableViewCellViewData.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 2/8/17.
//  Copyright © 2017 Olga Pudrovska. All rights reserved.
//

import Foundation
import UIKit

struct FeedTableViewCellViewData {

    let content: ContentItem

    let titleLabelText: String
    let blurbLabelText: String
    let dateLabelText: String
    let imageURL: String

    init(content: ContentItem) {
        self.content = content
        
        self.titleLabelText = content.title
        self.blurbLabelText = content.blurb

        // Convert milliseconds since 1970 to a human-readable date string
        let timeInterval = TimeInterval(content.datePublished)
        let date = Date(timeIntervalSince1970: timeInterval)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        self.dateLabelText = dateFormatter.string(from: date)

        self.imageURL = content.imageURL
    }
}
