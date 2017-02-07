//
//  FeedViewData.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 2/5/17.
//  Copyright © 2017 Olga Pudrovska. All rights reserved.
//

import Foundation

struct FeedViewData {
    var content: [ContentItem] {
        return self._content
    }

    var filteredContent: [ContentItem] {
        return self._filteredContent
    }

    var sortOrder: SortOrder {
        return self._sortOrder
    }

    var sortType: SortType {
        return self._sortType
    }

    var title: String {
        return self._title
    }

    fileprivate var _content: [ContentItem]
    fileprivate var _filteredContent: [ContentItem]
    fileprivate var _sortOrder: SortOrder
    fileprivate var _sortType: SortType
    fileprivate var _title: String

    init(content: [ContentItem]) {
        self._content = content
        self._filteredContent = []
        self._sortOrder = .ascending
        self._sortType = .title
        self._title = FeedLocalizationKey.posts.localizedString()
    }

    mutating func updateContent(content: [ContentItem]) {
        self._content = content
    }

    mutating func updateFilteredContent(filteredContent: [ContentItem]) {
        self._filteredContent = filteredContent
    }

    mutating func updateSortType(sortType: SortType) {
        self._sortType = sortType
    }

    mutating func updateSortOrder(sortOrder: SortOrder) {
        self._sortOrder = sortOrder
    }

    mutating func findText(searchText :String) {
        self._filteredContent = self._content.filter { (contentItem: ContentItem) -> Bool in
            return contentItem.title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive) == nil || contentItem.blurb.range(of: searchText, options: NSString.CompareOptions.caseInsensitive) != nil
        }
    }

    mutating func sortContent(sortType: SortType, sortOrder: SortOrder) {
        self.updateSortType(sortType: sortType)
        self.updateSortOrder(sortOrder: sortOrder)
        switch sortType {
        case .title:
            self._content.sort { self.before(lhs: $0.title, rhs: $1.title, sortOrder: sortOrder) }
            break
        case .date:
            self._content.sort { self.before(lhs: $0.datePublished, rhs: $1.datePublished, sortOrder: sortOrder) }
            break
        }
    }

    fileprivate func before<T: Comparable>(lhs: T, rhs: T, sortOrder: SortOrder) -> Bool {
        return sortOrder == .ascending ? lhs < rhs : lhs > rhs
    }
}
