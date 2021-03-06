//
//  ViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/17/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit

class BoroughsViewController: UITableViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let textLabel = cell!.contentView.subviews[0] as UILabel
        NSLog("Selected Filter: \(textLabel.text)")

        NSNotificationCenter.defaultCenter().postNotificationName(PostsViewController.PostFilterNotificationKey, object: PostFilter.mappedFilters(textLabel.text))
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

