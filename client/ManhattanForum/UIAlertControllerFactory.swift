//
//  BlockAlertViewDelegate.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 10/4/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit

class UIAlertControllerFactory {
    class func ok(title: String, message: String) -> UIAlertController {
        var alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        return alertController
    }
}
