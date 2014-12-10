//
//  PFObject.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 12/1/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

extension PFObject {
    func saveEventuallyAsTask() -> BFTask! {
        var deferred = BFTaskCompletionSource()

        saveEventually({ (success, error) -> Void in
            if(success) {
                deferred.setResult(self)
            } else {
                deferred.setError(error)
            }
        })
        
        return deferred.task
    }
}