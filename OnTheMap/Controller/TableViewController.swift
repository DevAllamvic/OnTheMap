//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Osama Allam on 6/26/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var studentLocations: [Student] = []
    
    @IBOutlet weak var listTable: UITableView!
    
    var Key: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Key = UserDefaults.standard.string(forKey: "user_key")!
        
        listTable.delegate = self
        listTable.dataSource = self
        
        self.getStudentsData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if studentLocations.count > 0 {
            self.listTable.reloadData()
        } else {
            self.getStudentsData()
        }
    }
    
    
    func getStudentsData(){
        StudentsClient().getStudentsLocations(studentKey: ""){locations,error in
            DispatchQueue.main.async {
                if error != nil {
                    AlertHelper.showMessage(view: self, title: "Error", error: error!.localizedDescription)
                } else  {
                    self.studentLocations.removeAll()
                    self.studentLocations = locations!
                    self.listTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "logged")
        UserDefaults.standard.removeObject(forKey: "user_key")
        
        AuthClient().logoutUser(){ isCompleted, error in
            DispatchQueue.main.async {
                if isCompleted{
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(homeViewController!, animated: true, completion: nil)
                }else{
                    AlertHelper.showMessage(view: self, title: "Error", error: error!.localizedDescription)
                }
            }
        }
    }

    
    @IBAction func addButton(_ sender: Any) {
        StudentsClient().getStudentsLocations(studentKey: Key) { locationList, error  in
            DispatchQueue.main.async {
                if error != nil {
                    AlertHelper.showMessage(view: self, title: "Error", error: error!.localizedDescription)
                } else {
                    if locationList != nil && locationList!.count > 0 {
                        let alert = UIAlertController(title: "", message: "You Have Already Posted a Student Location, Would You Like to Overwrite Your Current Location?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {(action:UIAlertAction!) in
                            self.goToAdd()
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        self.present(alert,animated: true, completion: nil)
                    }else {
                        self.goToAdd()
                    }
                }
            }
        }
    }
    
    func goToAdd(){
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationNav")
        self.present(homeViewController!, animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        getStudentsData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        let studentLocation = studentLocations[indexPath.row]
        cell.textLabel?.text = studentLocation.firstName + " " + studentLocation.lastName
        cell.detailTextLabel?.text = studentLocation.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = studentLocations[indexPath.row].mediaURL
        let url = URL(string: location)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            AlertHelper.showMessage(view: self, title: "Error", error: "Invalid URL")
        }
    }
}
