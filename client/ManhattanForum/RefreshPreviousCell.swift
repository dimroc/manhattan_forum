//
//  RefreshPreviousCell.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/15/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation

class RefreshPreviousCell: UITableViewCell {
    @IBAction func notifyRefresh(sender: UIButton) {
        DDLogHelper.debug("Loading previous posts");
        NSNotificationCenter.defaultCenter().postNotificationName(PostsViewController.TopicsViewRefreshNotificationKey, object: self)
    }
}