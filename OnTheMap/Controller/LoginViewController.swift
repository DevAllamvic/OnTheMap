//
//  ViewController.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var logged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        if UserDefaults.standard.string(forKey: "logged") == "true"{
            logged = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if logged == true{
            self.goHome()
        }
    }
    
    func goHome(){
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        self.present(homeViewController!, animated: true, completion: nil)
    }


    @IBAction func LoginUser(_ sender: Any) {
        
        loginBtn.isEnabled = false
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            loginBtn.isEnabled = true
        
            AlertHelper.showMessage(view: self,title: "Error",error: "PLZ enter email and password")
        } else {
            AuthClient().loginUser(email: emailTextField.text!, password: passwordTextField.text!){
                (authModel, error) in
                
                DispatchQueue.main.async {
                    
                    self.loginBtn.isEnabled = true
                    
                    if error != nil {
                        AlertHelper.showMessage(view: self, title: "Error", error: error!.localizedDescription)
                    } else {
                        if authModel?.account?.registered == true {
                            
                            UserDefaults.standard.set("true",forKey: "logged")
                            
                            UserDefaults.standard.set((authModel?.account?.key)!,forKey: "user_key")
                            
                            self.goHome()
                            
                        } else {
                            AlertHelper.showMessage(view: self, title: "Oops", error: "You didn't register yet :| ")
                        }
                    }
                }
                
            }
            
            
        }
        
    }
    
    @IBAction func SignUpUser(_ sender: Any) {
        let url = URL(string: Constants.Auth.signUpURL)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

