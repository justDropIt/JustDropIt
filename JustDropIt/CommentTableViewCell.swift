//
//  CommentTableViewCell.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 12/5/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var professorLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var vibeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onLikeButton(_ sender: Any) {
    }
    
    @IBAction func onVibeButton(_ sender: Any) {
    }
    
}
