//
//  PostsViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/19/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {
    var cellHeights = [String: CGFloat]()

    class var TopicsViewRefreshNotificationKey: String! {
        get { return "TopicsViewRefreshNotificationKey" }
    }
    
    class var PostMoviePlaybackNotificationKey: String! {
        get { return "PostMoviePlaybackNotificationKey" }
    }
    
    class var PostFilterNotificationKey: String! {
        get { return "PostFilterNotificationKey" }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        registerNibCell("PostCell")
        registerNibCell("RefreshPreviousCell")
        
        self.navigationItem.title = "NYC"

        let postDataSource = self.tableView.dataSource as PostDataSource
        postDataSource.postFilter = PostFilter.mappedFilters("NYC")
        postDataSource.refreshFromLocal()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshPrevious", name: PostsViewController.TopicsViewRefreshNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh:", name: PostRepository.PostCreatedNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "presentMovie:", name: PostsViewController.PostMoviePlaybackNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "filterPosts:", name: PostsViewController.PostFilterNotificationKey, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let postDataSource = self.tableView.dataSource as PostDataSource
        if(indexPath.row >= postDataSource.posts.count) {
            return cellHeights["RefreshPreviousCell"]!
        } else {
            return cellHeights["PostCell"]!
        }
    }

    @IBAction func refresh(sender: AnyObject) {
        let postDataSource = self.tableView.dataSource as PostDataSource
        handleRefresh(postDataSource.refresh())
    }
    
    func presentMovie(notification: NSNotification) {
        let post = notification.object as Post
        let moviePlayer = MPMoviePlayerViewController(contentURL: NSURL(string: post.video.url))
        self.presentMoviePlayerViewControllerAnimated(moviePlayer)
        
        let overlayView:UIView! = UIView()
        moviePlayer.moviePlayer.overlayView_xcd = overlayView;
    }
    
    func filterPosts(notification: NSNotification) {
        let postFilter = notification.object as PostFilter
        let postDataSource = self.tableView.dataSource as PostDataSource
        postDataSource.postFilter = postFilter
        refresh(self)
    }

    func refreshPrevious() {
        let postDataSource = self.tableView.dataSource as PostDataSource
        handleRefresh(postDataSource.refreshPrevious())
    }

    private func handleRefresh(task: BFTask!) {
        task.continueWithBlockOnMain { (task: BFTask!) -> AnyObject! in
            if (task.success) {
                self.tableView.reloadData()
            } else {
                DDLogHelper.debug(task.error.debugDescription)
                
                self.presentViewController(
                    UIAlertControllerFactory.ok("Error refreshing previous posts", message: task.error.localizedDescription),
                    animated: true,
                    completion: nil)
            }
            
            self.refreshControl?.endRefreshing()
            return nil
        }
    }

    private func registerNibCell(cellName: String!) {
        let nib = UINib(nibName: cellName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellName)
        
        let uiview = NSBundle.mainBundle().loadNibNamed(cellName, owner: self, options: nil)[0] as? UIView
        cellHeights[cellName] = uiview?.bounds.size.height
    }
}