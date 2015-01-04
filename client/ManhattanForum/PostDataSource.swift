//
//  PostDataSource.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/4/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation
import UIKit

class PostDataSource: NSObject, UITableViewDataSource {
    var posts: Array<PFObject> = []

    func refreshFromLocal() {
        self.posts = self.buildPostsFromLocalStore()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if (self.posts.isEmpty) {

            // Display a message when the table is empty
            let messageLabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))

            messageLabel.text = "No posts!\nPlease pull down to refresh.";
            messageLabel.textColor = UIColor.blackColor();
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignment.Center;
            messageLabel.font = UIFont(name: "OpenSans-Regular", size: 16)
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
            return 0;
        } else {
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine;
            
            return 1;
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PostCell"
        let cell: PostCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as PostCell
        cell.populateFromPost(self.posts[indexPath.row])
        return cell
    }
    
    func refresh() -> BFTask! {
        return retrieveAsync().continueWithSuccessBlock({ (task: BFTask!) -> AnyObject! in
            let newPosts = task.result as Array<PFObject>
            let success: Bool = PFObject.pinAll(newPosts, withName: "Posts")
            if(success) {
                self.posts = self.buildPostsFromLocalStore()
            } else {
                NSLog("FAILED TO PIN OBJECTS")
            }
            return nil
        })
    }
    
    private func buildPostsFromLocalStore() -> Array<PFObject> {
        let query = defaultQuery()
        query.fromPinWithName("Posts")
        
        let objects = query.findObjects()
        NSLog("Built \(objects.count) posts from local data store")
        return objects as Array<PFObject>
    }
    
    private func retrieveAsync() -> BFTask! {
        let query = defaultQuery()
        query.limit = 100
        return query.findObjectsInBackground()
    }
    
    private func defaultQuery() -> PFQuery {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        return query
    }
}