//
//  TopicsViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/19/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit

class TopicsViewController: UITableViewController {
    var posts: Array<PFObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        let nib = UINib(nibName: "PostCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PostCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if (self.posts.isEmpty) {
            
            // Display a message when the table is empty
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            
            messageLabel.text = "No data is currently available. Please pull down to refresh.";
            messageLabel.textColor = UIColor.blackColor();
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignment.Center;
            messageLabel.font = UIFont(name: "OpenSans-Regular", size: 16)
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
            return 0;
        } else {
            self.tableView.backgroundView = nil;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;

            return 1;
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PostCell"
        let cell: PostCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as PostCell
        cell.populateFromPost(self.posts[indexPath.row])
        return cell
    }
    
    @IBAction func refresh(sender: AnyObject) {
        PostRepository.retrieveAsync().continueWithBlockOnMain { (task: BFTask!) -> AnyObject! in
            if (task.success) {
                self.posts = task.result as Array<PFObject>
                self.tableView.reloadData()
            } else {
                NSLog(task.error.debugDescription)
                
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