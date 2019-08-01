//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var locationTextFiled: UITextField!
    @IBOutlet weak var linkTextField: UITextField!

    var objectID: String = ""
    var userKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextFiled.delegate = self
        linkTextField.delegate = self
        
        userKey = UserDefaults.standard.string(forKey: "user_key")!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        StudentsClient().getStudentsLocations(studentKey: userKey) { locationList, error  in
            DispatchQueue.main.async {
                if error != nil {
                    return
                } else {
                    if locationList != nil && locationList!.count > 0 {
                        self.objectID = locationList![0].objectId
                    }
                }
            }
        }
    }

    @IBAction func finLocationButton(_ sender: Any) {
        if locationTextFiled.text!.isEmpty {
            AlertHelper.showMessage(view: self, title: "Oops", error: "Please enter location")
        } else if linkTextField.text!.isEmpty {
            AlertHelper.showMessage(view: self, title: "Oops", error: "Please enter your link")
        } else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "LocationPostingView") as! SetLocationViewController
            next.objectID = objectID
            next.userKey = userKey
            next.location = locationTextFiled.text!
            next.url = linkTextField.text!
            navigationController?.pushViewController(next, animated: true)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
}
