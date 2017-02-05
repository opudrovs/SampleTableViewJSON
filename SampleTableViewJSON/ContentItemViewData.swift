//
//  ContentItemViewData.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 2/5/17.
//  Copyright © 2017 Olga Pudrovska. All rights reserved.
//

import Foundation

struct ContentItemViewData {
    
    let content: ContentItem

    let path: String?
    let title: String?

    init(content: ContentItem) {
        self.content = content
        self.path = content.path
        self.title = content.title
    }
}
