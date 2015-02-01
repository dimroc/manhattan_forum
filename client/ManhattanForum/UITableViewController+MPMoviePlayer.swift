//
//  UITableViewController+MPMoviePlayer.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 2/1/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation

extension UITableViewController {
    func presentMoviePlayerOverlay(url: NSURL) {
        let moviePlayer = MPMoviePlayerViewController(contentURL: url)
        self.presentMoviePlayerViewControllerAnimated(moviePlayer)
        
        let overlayView: UIView! = UIView()
        moviePlayer.moviePlayer.overlayView_xcd = overlayView;
    }
}