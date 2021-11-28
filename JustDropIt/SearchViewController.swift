//
//  SearchViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var professors = [PFObject]()
    
    var selectedProfessorString = ""
    
    var professorArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let query = PFQuery(className:"Posts")
        query.selectKeys(["professor"])
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // Do something with the found objects
                for object in objects {
                    let objectString = object["professor"] as! String
                    if !self.professorArray.contains(objectString) {
                        self.professorArray.append(objectString)
                    } else {
                        
                    }
                }
                
                self.professors = objects
                self.tableView.reloadData()
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        
        let professorString = professorArray[indexPath.row]

        cell.professorLabel.text = "@" + professorString
        
        tableView.rowHeight = 50
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        selectedProfessorString = row.professorLabel.text!
        
        self.performSegue(withIdentifier: "professorSegue", sender: nil)
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let professorViewController = segue.destination as! ProfessorViewController

        // Pass the selected object to the new view controller.
        professorViewController.selectedProfessor = selectedProfessorString
    }

}
