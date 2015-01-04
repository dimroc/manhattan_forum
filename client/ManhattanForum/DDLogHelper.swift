//
//  DDLogHelper.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/4/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation

public let defaultDebugLevel = DDLogLevel.Debug
public let defaultTag = NSString(format: "ManhattanForum")

class DDLogHelper {
    class func SwiftLogMacro(async: Bool, level: DDLogLevel, flag flg: DDLogFlag, context: Int = 0, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, tag: AnyObject? = defaultTag, format: String, args: CVaListPointer) {
        let string = NSString(format: format, arguments: args) as String
        SwiftLogMacro(async, level: level, flag: flg, context: context, file: file, function: function, line: line, tag: tag, string: string)
    }

    class func SwiftLogMacro(isAsynchronous: Bool, level: DDLogLevel, flag: DDLogFlag, context: Int = 0, file: String = __FILE__, function: String = __FUNCTION__, line: UInt = __LINE__, tag: AnyObject? = defaultTag, string: String) {
        // Tell the DDLogMessage constructor to copy the C strings that get passed to it.
        // Had to hardcode context to 0.
        let logMessage = DDLogMessage(message: string, level: level, flag: flag, context: context, file: file, function: function, line: line, tag: tag, options: DDLogMessageOptions.CopyFunction | DDLogMessageOptions.CopyFile, timestamp: NSDate())
        
        DDLog.log(isAsynchronous, message: logMessage)
    }

    class func debug(logText: String, level: DDLogLevel = defaultDebugLevel, file: String = __FILE__, function: String = __FUNCTION__, line: UWord = __LINE__, asynchronous async: Bool = true, args: CVarArgType...) {
        SwiftLogMacro(async, level: level, flag: DDLogFlag.Debug, file: file, function: function, line: line, format: logText, args: getVaList(args))
    }
}