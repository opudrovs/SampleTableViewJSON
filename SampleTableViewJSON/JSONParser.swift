//
//  JSONParser.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/29/16.
//  Copyright © 2016 Olga Pudrovska. All rights reserved.
//

import Foundation

typealias JSONArray = [AnyObject]
typealias JSONDictionary = [String: AnyObject]

struct ContentKey {
    static let blurb = "blurb"
    static let url = "url"
    static let title = "title"
    static let datePublished = "datePublished"
    static let urlImage = "urlImage"
}

struct JSONParser {
    static func parseDictionary(_ data: Data?) -> JSONDictionary? {
        do {
            if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary {
                return json
            }
        } catch {
            print("Couldn't parse JSON dictionary. Error: \(error)")
        }
        return nil
    }

    static func parseArray(_ data: Data?) -> JSONArray? {
        do {
            if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONArray {
                return json
            }
        } catch {
            print("Couldn't parse JSON array. Error: \(error)")
        }
        return nil
    }
    
    static func contentItemsFromResponse(_ data: Data?) -> [ContentItem]? {
        guard let parsedArray = parseArray(data) else {
            print("Error: couldn't parse array from data")
            return nil
        }
        
        guard let contentItems = parsedArray as? [JSONDictionary] else {
            print("Error: couldn't parse items from JSON: \(parsedArray)")
            return nil
        }
        
        return contentItems.flatMap { parseContentItem($0) }
    }
    
    static func parseContentItem(_ dict: JSONDictionary) -> ContentItem? {
        guard let blurb = dict[ContentKey.blurb] as? String, let url = dict[ContentKey.url] as? String, let title = dict[ContentKey.title] as? String, let datePublished = dict[ContentKey.datePublished] as? Int, let urlImage = dict[ContentKey.urlImage] as? String else {
            print("Error: couldn't parse JSON dictionary: \(dict)")
            return nil
        }

        let item = ContentItem(blurb: blurb, url: url, title: title, datePublished: datePublished, urlImage: urlImage)
        return item
    }
}
