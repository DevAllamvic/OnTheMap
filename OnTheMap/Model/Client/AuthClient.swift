//
//  AuthClient.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//
import Foundation
import UIKit

class AuthClient: NSObject {
    
    
    func loginUser(email: String , password: String , completion: @escaping (Auth? , Error?) -> Void){
    
        var request = URLRequest(url: URL(string: Constants.Auth.loginURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil,error)
                return
            }
            if let data = data {
                let usableResult = data.subdata(in: 5..<data.count)
                do {
                    let authModel = try JSONDecoder().decode(Auth.self, from: usableResult)
                    completion(authModel, nil)
                }catch let error {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    func getUserPublicData(userID: String,completion: @escaping (String?,String?,Error?) -> Void){
        let request = URLRequest(url: URL(string : Constants.Auth.publicData+userID)!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil,nil,error)
                return
            }
            if let data = data {
                let newData = data.subdata(in: 5..<data.count)
                do{
                    let userModel = try JSONDecoder().decode(User.self, from: newData)
                    completion(userModel.firstName,userModel.lastName,nil)
                }catch let error {
                    completion(nil,nil,error)
                }
            }
        }
        task.resume()
    }
    
    
    func logoutUser (completion: @escaping (Bool,Error?) -> Void){
        var request = URLRequest(url: URL(string : Constants.Auth.loginURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data ,response , error in
            if error != nil {
                completion(false,error)
                return
            }
            completion(true,nil)
        }
        task.resume()
    }

}
