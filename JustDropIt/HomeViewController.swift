//
//  HomeViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var posts = [PFObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let thisUniversity = PFUser.current()!["university"] as! String
        
        let innerQuery : PFQuery = PFUser.query()!
        innerQuery.whereKey("university", equalTo: thisUniversity)
        
        let query = PFQuery(className:"Posts")
        query.whereKey("author", matchesQuery: innerQuery)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // Do something with the found objects
                self.posts = objects
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        
        let post = posts[indexPath.section]

        let professor = post["professor"] as! String
        let content = post["content"] as! String
        let likes = post["likes"] as! String
        let song = post["song"] as! String
        
        cell.likes = likes
        cell.post = post

        cell.professorLabel.text = "@" + professor
        cell.contentLabel.text = content
        cell.likesLabel.text = likes
        
        cell.song = song
        cell.viewController = self
        
        tableView.rowHeight = 150
        
        
        let userID = (PFUser.current()?.objectId)! as String
        cell.userID = userID
        
        let likedBy = post["likedBy"] as! Array<String>
        
        if likedBy.contains(userID) {
            cell.alreadyLiked()
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "vibeSegue" else {return}
        
        let cell = sender as! PostTableViewCell
        
        let song = cell.song
        
        let vibeViewController = segue.destination as! VibeViewController
        
        // Pass the selected object to the new view controller.
        vibeViewController.song = song
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
