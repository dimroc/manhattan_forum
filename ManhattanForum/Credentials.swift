//
//  Credentials.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/17/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

private let _singletonInstance = Credentials()
class Credentials {
    var credentials: NSDictionary
    
    class func objectForKey(key: NSString) -> NSString {
        return _singletonInstance.objectForKey(key) as NSString
    }
    
    init() {
        var pathForResource = ""
        #if DEBUG
            println("Initializing credentials for DEBUG")
            pathForResource = "Credentials.debug"
        #elseif RELEASE
            println("Initializing credentials for RELEASE")
            pathForResource = "Credentials.release"
        #endif
        
        let resource = NSBundle.mainBundle().pathForResource(pathForResource, ofType: "plist")
        assert(resource != nil, "Resource cannot be empty. Did you create your credentials file?")
        credentials = NSDictionary(contentsOfFile: resource)
    }
    
    func objectForKey(key: NSString) -> NSString {
        let encrypted = credentials.objectForKey(key) as NSString
        return decrypt(encrypted)
    }
    
    func decrypt(value: NSString) -> NSString {
        let data = NSData(base64EncodedString: value, options: NSDataBase64DecodingOptions.fromRaw(0)!)
        var error = NSErrorPointer()
        let decrypted = RNDecryptor.decryptData(data, withPassword: NSStringFromClass(AppDelegate), error: error)
        let rval = NSString(data: decrypted, encoding: NSUTF8StringEncoding)
        assert(rval != nil)
        return rval
    }
}