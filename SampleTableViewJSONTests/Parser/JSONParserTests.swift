//
//  ParserTests.swift
//  SampleTableViewJSON
//
//  Created by Olga Pudrovska on 3/30/16.
//  Copyright © 2016 Olga Pudrovska. All rights reserved.
//

import Foundation

import XCTest
@testable import SampleTableViewJSON

class JSONParserTests: XCTestCase {
    let parser = JSONParser()
    
    func testParseArray() {
        let data = loadJSONTestData("valid-response")
        let results = parser.parseArray(data)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(6, results!.count)
    }
    
    func testParseArray_with_invalid_JSON() {
        let data = loadJSONTestData("invalid-response")
        let results = parser.parseArray(data)
        
        XCTAssertNil(results)
    }
    
    func testContentItemsFromResponse() {
        let data = loadJSONTestData("valid-response")
        let results = parser.contentItemsFromResponse(data)
        XCTAssertEqual(6, results!.count)
        
        let first = results!.first!
        XCTAssertEqual("Historic win by Google DeepMind's Go-playing program has South Korean government playing catch-up on artificial intelligence.", first.blurb)
        XCTAssertEqual("http://www.nature.com/news/south-korea-trumpets-860-million-ai-fund-after-alphago-shock-1.19595", first.url)
        XCTAssertEqual("South Korea trumpets $860-million AI fund after AlphaGo 'shock'", first.title)
        XCTAssertEqual(1458284400, first.datePublished)
        XCTAssertEqual("http://olgapudrovska.com/images/korea_alpha_go.jpg", first.urlImage)
    }
    
    func test_contentItemsFromResponse_with_nil_data() {
        let data: NSData? = nil
        let results = parser.contentItemsFromResponse(data)
        XCTAssertNil(results)
    }
    
    func loadJSONTestData(filename: String) -> NSData? {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(filename, ofType: "json")
        return NSData(contentsOfFile: path!)
    }
}
