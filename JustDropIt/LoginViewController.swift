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
    
    @IBAction func onEnterButton(_ sender: Any) {
        self.performSegue(withIdentifier: "enterSegue", sender: nil)
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
