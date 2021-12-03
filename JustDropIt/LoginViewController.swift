//
//  LoginViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let universities = ["Red","Yellow","Green","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue","Blue"]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func onEnterButton(_ sender: Any) {
        let userID = randomString(length: 50)
        UserDefaults.standard.set(userID, forKey: "userID")
        
        let user = PFUser()
        user.username = userID
        user.password = "password"
        user.email = emailField.text!
        
        let pickedUniversity = universities[pickerView.selectedRow(inComponent: 0)]
        user["university"] = pickedUniversity
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                let errorString = error.localizedDescription
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { (alertAction) in })
                
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "enterSegue", sender: nil)
            }
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return universities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return universities[row]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }


}
