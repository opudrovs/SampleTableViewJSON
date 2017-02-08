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
    static let path = "url"
    static let title = "title"
    static let datePublished = "datePublished"
    static let imageURL = "urlImage"
}

class JSONParser {

    func parseDictionary(_ data: Data?) -> JSONDictionary? {
        do {
            if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary {
                return json
            }
        } catch {
            print("Couldn't parse JSON dictionary. Error: \(error)")
        }
        return nil
    }

    func parseArray(_ data: Data?) -> JSONArray? {
        do {
            if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONArray {
                return json
            }
        } catch {
            print("Couldn't parse JSON array. Error: \(error)")
        }
        return nil
    }
    
    func contentItemsFromResponse(_ data: Data?) -> [ContentItem]? {
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
    
    func parseContentItem(_ dict: JSONDictionary) -> ContentItem? {
        guard let blurb = dict[ContentKey.blurb] as? String, let path = dict[ContentKey.path] as? String, let title = dict[ContentKey.title] as? String, let datePublished = dict[ContentKey.datePublished] as? Int, let imageURL = dict[ContentKey.imageURL] as? String else {
            print("Error: couldn't parse JSON dictionary: \(dict)")
            return nil
        }

        let item = ContentItem(blurb: blurb, path: path, title: title, datePublished: datePublished, imageURL: imageURL)
        return item
    }
}
