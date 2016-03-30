//
//  DataProvider.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/29/16.
//  Copyright © 2016 Olga Pudrovska. All rights reserved.
//

import Foundation

class DataProvider {
    func loadData(completion: (NSData?) -> Void) {
        let urlString = "http://olgapudrovska.com:8091/sampledata/posts"

        guard let url = NSURL(string: urlString) else {
            print("Error: couldn't create URL from string")
            completion(nil)
            return
        }

        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let error = error {
                print("Error loading data: \(error)")
                completion(data)
                return
            }
            
            completion(data)
        }
        
        task.resume()
    }
}