//
//  SettingsViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    @IBAction func onResetButton(_ sender: Any) {
        
//        PFUser.current()?.deleteInBackground(block: { (success, error) -> Void in
//            if success {
//                UserDefaults.standard.removeObject(forKey: "userID")
//
//                let main = UIStoryboard(name: "Main", bundle: nil)
//                let LoginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
//
//                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
//
//                delegate.window?.rootViewController = LoginViewController
//            } else {
//                print(error)
//            }
//        })
        
        PFUser.logOutInBackground(block: { (error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                UserDefaults.standard.removeObject(forKey: "userID")

                let main = UIStoryboard(name: "Main", bundle: nil)
                let LoginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")

                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }

                delegate.window?.rootViewController = LoginViewController
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
