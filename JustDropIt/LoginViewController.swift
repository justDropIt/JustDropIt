//
//  LoginViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate {
    
    var universities = [String]()
    
    var filteredUniversities = [String]()
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func onEnterButton(_ sender: Any) {
        let userID = randomString(length: 50)
        UserDefaults.standard.set(userID, forKey: "userID")
        
        let user = PFUser()
        user.username = userID
        user.password = "password"
        user.email = emailField.text!
        
        let pickedUniversity = filteredUniversities[pickerView.selectedRow(inComponent: 0)]
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
        return filteredUniversities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredUniversities[row]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUniversities = searchText.isEmpty ? universities : universities.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        pickerView.reloadAllComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let url = URL(string: "http://universities.hipolabs.com/search?country=united%20states")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                 let dataArray = try! JSONSerialization.jsonObject(with: data, options: []) as! NSArray

                 var newArray = [String]()
                 
                 for universityObject in dataArray {
                     newArray.append((universityObject as! [String: Any])["name"]! as! String)
                 }
                 self.universities = newArray
                 self.filteredUniversities = self.universities
                 self.pickerView.reloadAllComponents()
             }
        }
        task.resume()
    }


}
