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
    @IBOutlet weak var songTextField: UITextField!
    
    
    var selectedProfessor = ""
    
    let likes = "0"
    let likedBy = [PFObject]()
    let author = PFUser.current()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentTextView.delegate = self
        
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 10
        
        professorLabel.text = "@" + selectedProfessor
        
        _ = PFUser.current()?.object(forKey: "emailVerified")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        contentTextView.text = nil
    }
    
    @IBAction func onPostButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        let university = PFUser.current()!["university"] as! String
        
        let song = songTextField.text
        
        post["author"] = PFUser.current()
        post["professor"] = selectedProfessor
        post["content"] = contentTextView.text
        post["song"] = song
        post["likes"] = likes
        post["likedBy"] = likedBy
        post["university"] = university
        
        post.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                self.dismiss(animated: true, completion: nil)
            } else {
                // There was a problem, check error.description
                let errorString = error?.localizedDescription
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { (alertAction) in })
                
                self.present(alert, animated: true, completion: nil)
            }
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
