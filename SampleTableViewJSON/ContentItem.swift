//
//  ContentItem.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/28/15.
//  Copyright (c) 2016 Olga Pudrovska. All rights reserved.
//

import Foundation

struct ContentItem {
    
    var blurb: String
    var path: String
    var title: String
    var datePublished: Int
    var imageURL: String

    init(blurb: String, path: String, title: String, datePublished: Int, imageURL: String) {
        self.blurb = blurb
        self.path = path
        self.title = title
        self.datePublished = datePublished
        self.imageURL = imageURL
    }
}
