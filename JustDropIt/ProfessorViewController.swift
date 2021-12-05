//
//  ProfessorViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse

class ProfessorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedProfessor = ""
    
    var refreshControl: UIRefreshControl!
    
    var posts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        professorLabel.text = selectedProfessor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedProfessor.removeFirst()
        
        populatePosts()
    }
    
    func populatePosts() {
        let thisUniversity = PFUser.current()!["university"] as! String
        
        let innerQuery : PFQuery = PFUser.query()!
        innerQuery.whereKey("university", equalTo: thisUniversity)
        
        let query = PFQuery(className:"Posts")
        query.whereKey("author", matchesQuery: innerQuery)
        query.whereKey("professor", equalTo: selectedProfessor)

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessorTableViewCell") as! ProfessorTableViewCell
        
        let post = posts[indexPath.section]

        let content = post["content"] as! String
        let likes = post["likes"] as! String
        let song = post["song"] as! String
        
        cell.likes = likes
        cell.post = post

        cell.song = song
        cell.viewController = self
        
        cell.contentLabel.text = content
        cell.likesLabel.text = likes
        
        tableView.rowHeight = 150
        
        
        let userID = (PFUser.current()?.objectId)! as String
        cell.userID = userID
        
        let likedBy = post["likedBy"] as! Array<String>
        
        if likedBy.contains(userID) {
            cell.alreadyLiked()
        }
        
        return cell
    }
    
    @objc func onRefresh() {
        populatePosts()
        refreshControl.endRefreshing()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createSegue" {
            // Get the new view controller using segue.destination.
            let createViewController = segue.destination as! CreateViewController

            // Pass the selected object to the new view controller.
            createViewController.selectedProfessor = selectedProfessor
        } else if segue.identifier == "vibeSegue2" {
            let cell = sender as! ProfessorTableViewCell
            
            let song = cell.song
            
            let vibeViewController = segue.destination as! VibeViewController
            
            // Pass the selected object to the new view controller.
            vibeViewController.song = song
        }
    }

}
