//
//  PostTableViewCell.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/25/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var songLabel: UILabel!
    
    var liked: Bool = false
    
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
        self.liked = true
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
    }
    
    func unlike() {
        self.liked = false
        likeButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
    }

}
