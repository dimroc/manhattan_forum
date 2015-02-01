//
//  PostDetailsViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/31/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation
import UIKit

class PostDetailsViewController: UITableViewController {
    var cellHeights = [String: CGFloat]()
    var post: Post? = nil

    override func viewDidLoad() {
        registerNibCell("PostCell")
        registerNibCell("CommentCell")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return cellHeights["PostCell"]!
        } else {
            return cellHeights["CommentCell"]!
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cellIdentifier = "PostCell"
            let cell: PostCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as PostCell
            cell.populateFromPost(self.post, delegate: self)
            return cell
        } else {
            let cellIdentifier = "CommentCell"
            let cell: CommentCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as CommentCell
//            cell.populate(self.post, delegate: self)
            return cell
        }
    }
    
    private func registerNibCell(cellName: String!) {
        let nib = UINib(nibName: cellName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellName)
        
        let uiview = NSBundle.mainBundle().loadNibNamed(cellName, owner: self, options: nil)[0] as? UIView
        cellHeights[cellName] = uiview?.bounds.size.height
    }
}

extension PostDetailsViewController: PostHandable {
    func playPostVideo(post: Post!) {
        presentMoviePlayerOverlay(NSURL(string: post.video.url)!)
    }

    func showPostDetails(post: Post!) {
        // NOOP
    }
}
