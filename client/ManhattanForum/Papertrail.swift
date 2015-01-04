//
//  Papertrail.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/4/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation

class Papertrail {
    class func launch() {
        let paperTrailLogger = RMPaperTrailLogger.sharedInstance()
        paperTrailLogger.host = Credentials.objectForKey("PapertrailHost")
        let portString: String = Credentials.objectForKey("PapertrailPort")
        paperTrailLogger.port = UInt(portString.toInt()!)

        DDLog.addLogger(paperTrailLogger)
        DDLog.addLogger(DDASLLogger.sharedInstance())
        DDLog.addLogger(DDTTYLogger.sharedInstance())

        DDLogHelper.debug("Launching Papertrail logging for ManhattanForum")
//        DDLog("Hi PaperTrailApp.com")
    }
}