//
//  FeedLocalizationKey.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 2/3/17.
//  Copyright © 2017 Olga Pudrovska. All rights reserved.
//

import Foundation

enum FeedLocalizationKey : String {
    case posts
    case searchPlaceholder
    case sortContentBy
    case sortCancelAction
    case sortTypeByTitle
    case sortTypeByDatePublished
    case sortOrderAscending
    case sortOrderDescending
    case sort

    static let tableName = "General"
    static let bundleIdentifier = Bundle.main.bundleIdentifier!

    func localizedKey() -> String {
        switch self {
        case .posts: return "feed.title.posts"
        case .searchPlaceholder: return "feed.title.search-placeholder"
        case .sortContentBy: return "feed.title.sort-content-by"
        case .sortCancelAction: return "feed.title.sort-cancel-action"
        case .sortTypeByTitle: return "feed.title.sort-type-by-title"
        case .sortTypeByDatePublished: return "feed.title.sort-type-by-date-published"
        case .sortOrderAscending: return "feed.title.sort-order-ascending"
        case .sortOrderDescending: return "feed.title.sort-order-descending"
        case .sort: return "feed.title.sort"
        }
    }

    func localizedString() -> String {
        return NSLocalizedString(self.localizedKey(), tableName: FeedLocalizationKey.tableName, bundle: Bundle(identifier: FeedLocalizationKey.bundleIdentifier) ?? Bundle.main , value: "", comment: "")
    }
}
