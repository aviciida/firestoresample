//
//  PostTableViewCell.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/07.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var likedLabel: UILabel!
    @IBOutlet weak var likeIconImage: UIImageView!
    
    var currentUserLikedHandler: ((IndexPath?)->Void)? = nil
    var currentUserDislikedHandler:((IndexPath?)->Void)? = nil
    var currentUserLikedThisPost: Bool = false
    
    @IBAction func likeButtonDidTap(_ sender: Any) {
        if currentUserLikedThisPost {
            currentUserDislikedHandler?(getIndexPath())
        } else {
            currentUserLikedHandler?(getIndexPath())
        }
        
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}
