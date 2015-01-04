//
//  TopicsViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/19/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit

class TopicsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        let nib = UINib(nibName: "PostCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PostCell")

        let postDataSource = self.tableView.dataSource as PostDataSource
        postDataSource.refreshFromLocal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refresh(sender: AnyObject) {
        let postDataSource = self.tableView.dataSource as PostDataSource
        postDataSource.refresh().continueWithBlockOnMain { (task: BFTask!) -> AnyObject! in
            if (task.success) {
                self.tableView.reloadData()
            } else {
                DDLogHelper.debug(task.error.debugDescription)
                
                self.presentViewController(
                    UIAlertControllerFactory.ok("Error refreshing", message: task.error.localizedDescription),
                    animated: true,
                    completion: nil)
            }

            self.refreshControl?.endRefreshing()
            return nil
        }
    }
}