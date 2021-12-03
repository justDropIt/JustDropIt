//
//  SearchViewController.swift
//  JustDropIt
//
//  Created by Aaryan Dehade on 11/23/21.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addProfessorButton: UIBarButtonItem!
    
    var professors = [PFObject]()
    
    var selectedProfessorString = ""
    
    var professorArray = [String]()
    var filteredProfessorArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self

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
                
                self.filteredProfessorArray = self.professorArray
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
                
                self.filteredProfessorArray = self.professorArray
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProfessorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        
        let professorString = filteredProfessorArray[indexPath.row]

        cell.professorLabel.text = "@" + professorString
        
        tableView.rowHeight = 50
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        selectedProfessorString = row.professorLabel.text!
        
        self.performSegue(withIdentifier: "professorSegue", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProfessorArray = searchText.isEmpty ? professorArray : professorArray.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    
    @IBAction func onAddProfessorButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add Professor", message: "Enter name of new professor", preferredStyle: .alert)
        alert.addTextField{ textField in
            textField.placeholder = "Professor"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let professorName = (alert?.textFields![0])?.text
            self.professorArray.append(professorName!)
            
            self.filteredProfessorArray = self.professorArray
            
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
        
        self.present(alert, animated: true, completion: nil)
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
