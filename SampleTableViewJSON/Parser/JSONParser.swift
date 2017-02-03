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
        guard let arr = parseArray(data) else {
            print("Error: couldn't parse array from data")
            return nil
        }
        
        guard let contentItems = arr as? [JSONDictionary] else {
            print("Error: couldn't parse items from JSON: \(arr)")
            return nil
        }
        
        return contentItems.flatMap { parseContentItem($0) }
    }
    
    func parseContentItem(_ dict: JSONDictionary) -> ContentItem? {
        guard let blurb = dict["blurb"] as? String, let url = dict["url"] as? String, let title = dict["title"] as? String, let datePublished = dict["datePublished"] as? Int, let urlImage = dict["urlImage"] as? String else {
            print("Error: couldn't parse JSON dictionary: \(dict)")
            return nil
        }

        let item = ContentItem(blurb: blurb, url: url, title: title, datePublished: datePublished, urlImage: urlImage)
        return item
    }
}
