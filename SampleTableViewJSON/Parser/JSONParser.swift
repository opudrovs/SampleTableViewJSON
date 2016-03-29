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
    func parseDictionary(data: NSData?) -> JSONDictionary? {
        do {
            if let data = data, json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONDictionary {
                return json
            }
        } catch {
            print("Couldn't parse JSON dictionary. Error: \(error)")
        }
        return nil
    }

    func parseArray(data: NSData?) -> JSONArray? {
        do {
            if let data = data, json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONArray {
                return json
            }
        } catch {
            print("Couldn't parse JSON array. Error: \(error)")
        }
        return nil
    }
    
    func contentItemsFromResponse(data: NSData?) -> [ContentItem]? {
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
    
    func parseContentItem(dict: JSONDictionary) -> ContentItem? {
        if let  blurb = dict["blurb"] as? String,
                url = dict["url"] as? String,
                title = dict["title"] as? String,
                datePublished = dict["datePublished"] as? Int,
                urlImage = dict["urlImage"] as? String {

                let item = ContentItem(blurb: blurb, url: url, title: title, datePublished: datePublished, urlImage: urlImage)

                return item
        } else {
            print("Error: couldn't parse JSON dictionary: \(dict)")
        }
        return nil
    }
}