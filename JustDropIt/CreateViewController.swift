//
//  CreateViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse

class CreateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var professorLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var chooseSongButton: UIButton!
    
    var selectedProfessor = ""
    
    let likes = "0"
    let likedBy = [PFObject]()
    let author = PFUser.current()
    let content = ""
    let song = "new song"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentTextView.delegate = self
        
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 10
        
        professorLabel.text = "@" + selectedProfessor
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTextView.text = nil
    }
    
    @IBAction func onPostButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["author"] = PFUser.current()
        post["professor"] = selectedProfessor
        post["content"] = contentTextView.text
        post["song"] = song
        post["likes"] = likes
        post["likedBy"] = likedBy
        
        post.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                print("saved")
            } else {
                // There was a problem, check error.description
                print(error?.localizedDescription as Any)
            }
        }
        
        dismiss(animated: true, completion: nil)
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
