//
//  DismissSegue.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/21/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit

@objc(DismissSegue)
class DismissSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.sourceViewController as UIViewController
        src.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}