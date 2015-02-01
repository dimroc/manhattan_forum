//
//  PostCommentsViewController.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 1/31/15.
//  Copyright (c) 2015 dimroc. All rights reserved.
//

import Foundation
import UIKit

class PostCommentsViewController: UITableViewController {
    var cellHeights = [String: CGFloat]()

    override func viewDidLoad() {
        registerNibCell("PostCell")
        registerNibCell("CommentCell")
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let postDataSource = self.tableView.dataSource as PostDataSource
        if(indexPath.row == 0) {
            return cellHeights["PostCell"]!
        } else {
            return cellHeights["CommentCell"]!
        }
    }
    
    private func registerNibCell(cellName: String!) {
        let nib = UINib(nibName: cellName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellName)
        
        let uiview = NSBundle.mainBundle().loadNibNamed(cellName, owner: self, options: nil)[0] as? UIView
        cellHeights[cellName] = uiview?.bounds.size.height
    }
}