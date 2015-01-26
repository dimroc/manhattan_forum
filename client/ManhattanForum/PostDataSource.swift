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
    var posts: Array<Post> = []
    var postFilter: PostFilter = PostFilter.empty()
    var limit: Int {
        get { return 20 }
    }

    func refreshFromLocal() {
        self.posts = self.buildPostsFromLocalStore(currentQuery())
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
        return self.posts.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row >= self.posts.count) {
            let cellIdentifier = "RefreshPreviousCell"
            let cell: RefreshPreviousCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as RefreshPreviousCell
            return cell
        } else {
            let cellIdentifier = "PostCell"
            let cell: PostCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as PostCell
            cell.populateFromPost(self.posts[indexPath.row])
            return cell
        }
    }
    
    func refresh() -> BFTask! {
        return handleRetrieval(retrieveAsync())
    }
    
    func refreshPrevious() -> BFTask! {
        return handleRetrieval(retrievePreviousAsync())
    }
    
    private func handleRetrieval(task: BFTask!) -> BFTask! {
        return task.continueWithSuccessBlock({ (task: BFTask!) -> AnyObject! in
            let newPosts = task.result as Array<Post>
            DDLogHelper.debug("Retrieved remotely \(newPosts.count) posts")
            
            if(newPosts.count > 0 ) {
                let success: Bool = Post.pinAll(newPosts, withName: "Posts")
                if(!success) {
                    DDLogHelper.debug("FAILED TO PIN OBJECTS")
                }
            }

            self.posts = self.buildPostsFromLocalStore(self.currentQuery())
            return nil
        })
    }
    
    private func buildPostsFromLocalStore(query: PFQuery) -> Array<Post> {
        query.fromPinWithName("Posts")
        let objects = query.findObjects()
        DDLogHelper.debug("Built \(objects.count) posts from local data store")
        return objects as Array<Post>
    }
    
    private func retrieveAsync() -> BFTask! {
        let lastBuild = self.posts.first
        DDLogHelper.debug("Retrieving remotely everything after \(lastBuild?.createdAt) with last build: \(lastBuild)")
        let query = currentQuery()
        query.limit = limit

        if (lastBuild != nil) {
            query.whereKey("createdAt", greaterThan: lastBuild!.createdAt)
        }
        
        return query.findObjectsInBackground()
    }
    
    private func retrievePreviousAsync() -> BFTask! {
        let query = Post.query()
        let firstBuild = self.posts.last
        
        if (firstBuild != nil) {
            DDLogHelper.debug("Retrieving remotely everything before \(firstBuild?.createdAt) with first build: \(firstBuild)")
            query.orderByDescending("createdAt")
            query.whereKey("createdAt", lessThan: firstBuild!.createdAt)
        } else {    // Empty
            DDLogHelper.debug("Retrieving remotely from the beginning")
            query.orderByAscending("createdAt")
        }

        self.postFilter.assignToQuery(query)
        query.limit = limit
        return query.findObjectsInBackground()
    }
    
    private func currentQuery() -> PFQuery {
        let query = Post.query()
        query.orderByDescending("createdAt")
        self.postFilter.assignToQuery(query)

        return query
    }
}