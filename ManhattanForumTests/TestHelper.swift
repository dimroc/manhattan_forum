//
//  TestHelper.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 9/15/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

class TestHelper {
    class func loadJsonFixture(path: String!) -> Dictionary<String, AnyObject> {
        let bundle = NSBundle(forClass: self)
        let resource = bundle.pathForResource(path, ofType: "json")
        let inputStream = NSInputStream(fileAtPath: resource!)
        inputStream!.open()
        
        return NSJSONSerialization.JSONObjectWithStream(inputStream!, options: NSJSONReadingOptions.allZeros, error: nil) as Dictionary<String, AnyObject>
    }
}