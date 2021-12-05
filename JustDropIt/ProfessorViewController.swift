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
    
    var posts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        professorLabel.text = selectedProfessor
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedProfessor.removeFirst()
        
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
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessorTableViewCell") as! ProfessorTableViewCell
        
        let post = posts[indexPath.row]

        let content = post["content"] as! String
        let likes = post["likes"] as! String
        let song = post["song"] as! String
        
        cell.likes = likes
        cell.post = post

        cell.contentLabel.text = content
        cell.likesLabel.text = likes
        cell.songLabel.text = song
        
        tableView.rowHeight = 150
        
        
        let userID = (PFUser.current()?.objectId)! as String
        cell.userID = userID
        
        let likedBy = post["likedBy"] as! Array<String>
        
        if likedBy.contains(userID) {
            cell.alreadyLiked()
        }
        
        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let createViewController = segue.destination as! CreateViewController

        // Pass the selected object to the new view controller.
        createViewController.selectedProfessor = selectedProfessor
    }

}
