//
//  DataProvider.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/29/16.
//  Copyright © 2016 Olga Pudrovska. All rights reserved.
//

import Foundation

struct DataURL {
    static let main = "http://olgapudrovska.com/sampledata/posts.json"
}

class DataProvider {

    func loadData(completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: DataURL.main) else {
            print("Error: couldn't create URL from string")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) -> Void in
            if let error = error {
                print("Error loading data: \(error)")
            }
            
            completion(data)
        }
        
        task.resume()
    }
}
