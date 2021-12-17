//
//  CommentTableViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 12/5/21.
//

import UIKit
import Parse

class CommentTableViewController: UITableViewController {
    
    var post = PFObject(className: "Posts")
    
    var comments = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var toReturn = 0
        
        if section == 0 {
            toReturn = 1
        } else if section == 1 {
            toReturn = comments.count
        } else if section == 2 {
            toReturn = 1
        }
        
        return toReturn
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnVal = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath)
        
        self.tableView.rowHeight = 150
        
        if indexPath.section == 0 {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            cell.professorLabel.text = post["professor"] as? String
            cell.contentLabel.text = post["content"] as? String
            cell.likesLabel.text = post["likes"] as? String
            
            self.tableView.rowHeight = 150
            
            return cell
            
        } else if indexPath.section == 1 && comments.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            
            let comment = comments[indexPath.row]
            
            cell.commentLabel.text = comment["text"] as? String
            
            self.tableView.rowHeight = 50
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath) as! AddCommentCell
            
            self.tableView.rowHeight = 50
            
            return cell
        }
        
        return returnVal
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
            let alert = UIAlertController(title: "Add Comment", message: "", preferredStyle: .alert)
            alert.addTextField{ textField in
                textField.placeholder = "Comment..."
            }
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
                let comment = PFObject(className: "Comments")
                comment["text"] = (alert?.textFields![0])?.text
                comment["post"] = self.post
                comment["author"] = PFUser.current()!

                self.post.add(comment, forKey: "comments")
                self.post.saveInBackground { (success, error) in
                    if success {
                        self.comments.append(comment)
                        tableView.reloadData()
                    } else {
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
