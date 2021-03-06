//
//  PostTableViewCell.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/25/21.
//

import UIKit
import Parse

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var vibeButton: UIButton!
    
    weak var viewController : UIViewController?
    var likes = ""
    var post = PFObject(className: "Posts")
    var userID = ""
    var liked: Bool = false
    var song = ""
    
    @IBAction func onLikeButton(_ sender: Any) {
        if !liked {
            like()
        } else {
            unlike()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func like() {
        liked = true
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
        
        // Increase Like Count
        let newLikeCount = String(Int(likes)! + 1)
        likesLabel.text = newLikeCount
        likes = newLikeCount
        
        // Update parse database
        post["likes"] = newLikeCount
        post.saveInBackground()
        
        var likedBy = post["likedBy"] as! Array<String>
        likedBy.append(userID)
        post["likedBy"] = likedBy
        post.saveInBackground()
    }
    
    func unlike() {
        liked = false
        likeButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
        
        // Decrease Like Count
        let newLikeCount = String(Int(likes)! - 1)
        likesLabel.text = newLikeCount
        likes = newLikeCount
        
        // Update parse database
        post["likes"] = newLikeCount
        post.saveInBackground()
        
        var likedBy = post["likedBy"] as! Array<String>
        likedBy.removeAll { $0 == userID }
        post["likedBy"] = likedBy
        post.saveInBackground()
    }
    
    func alreadyLiked() {
        if liked == false {
            liked = true
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func onVibeButton(_ sender: Any) {
        viewController!.performSegue(withIdentifier: "vibeSegue", sender: self)
    }
}
