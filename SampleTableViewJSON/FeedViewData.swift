//
//  FeedViewData.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 2/5/17.
//  Copyright © 2017 Olga Pudrovska. All rights reserved.
//

import Foundation

struct FeedViewData {
    
    let content: [ContentItem]

    init(content: [ContentItem]) {
        self.content = content
    }
}
