//
//  DataProvider.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/29/16.
//  Copyright © 2016 Olga Pudrovska. All rights reserved.
//

import Foundation

class DataProvider {
    func loadData(_ completion: @escaping (Data?) -> Void) {
        let urlString = "http://olgapudrovska.com:8091/sampledata/posts"

        guard let url = URL(string: urlString) else {
            print("Error: couldn't create URL from string")
            completion(nil)
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print("Error loading data: \(error)")
                completion(data)
                return
            }
            
            completion(data)
        }) 
        
        task.resume()
    }
}
