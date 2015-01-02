//
//  BFTask.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 12/1/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

extension BFTask {
    var success: Bool {
        get { return self.error == nil }
    }
    
    func continueWithBlockOnMain(block: BFContinuationBlock!) -> BFTask! {
        let mainExecutor = BFExecutor(dispatchQueue: dispatch_get_main_queue())
        return continueWithExecutor(mainExecutor, withBlock: block)
    }
}