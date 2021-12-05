//
//  HomeViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse
import MessageInputBar

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    var posts = [PFObject]()
    var selectedPost: PFObject!

    
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    
    @objc func keyboardWillBeHidden(note: Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        populatePosts()
    }
    
    
    
    func populatePosts() {
        let thisUniversity = PFUser.current()!["university"] as! String
        
        let innerQuery : PFQuery = PFUser.query()!
        innerQuery.whereKey("university", equalTo: thisUniversity)
        
        let query = PFQuery(className:"Posts")
        query.whereKey("author", matchesQuery: innerQuery)
        query.includeKeys(["author" , "comments" , "comments.author"])
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // Do something with the found objects
                self.posts = objects
                self.posts.reverse()
                self.tableView.reloadData()
            }
        }
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Error saving comment")
            }
        }
    
        tableView.reloadData()
        
        // clear and dismiss the input bar
        commentBar.inputTextView.text = nil
        
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        
        let post = posts[indexPath.section]

        let professor = post["professor"] as! String
        let content = post["content"] as! String
        let likes = post["likes"] as! String
        let song = post["song"] as! String
        let comments = post["comments"] as? ([PFObject]) ?? []
        tableView.rowHeight = 150
        
        if indexPath.row == 0 {
        cell.likes = likes
        cell.post = post

        cell.professorLabel.text = "@" + professor
        cell.contentLabel.text = content
        cell.likesLabel.text = likes
        
        cell.song = song
        cell.viewController = self
        
        
        let userID = (PFUser.current()?.objectId)! as String
        cell.userID = userID
        
        let likedBy = post["likedBy"] as! Array<String>
        
        if likedBy.contains(userID) {
            cell.alreadyLiked()
        }
            
            return cell
            
        } else if indexPath.row <= comments.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comment Cell") as! CommentCell


            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String

            let user = comment["author"] as! PFUser
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "vibeSegue" else {return}
        
        let cell = sender as! PostTableViewCell
        
        let song = cell.song
        
        let vibeViewController = segue.destination as! VibeViewController
        
        // Pass the selected object to the new view controller.
        vibeViewController.song = song
    }
    
    @objc func onRefresh() {
        populatePosts()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = post["comments"] as? ([PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
 
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
