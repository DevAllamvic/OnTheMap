//
//  StudentsClient.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import UIKit

class StudentsClient: NSObject {
    
    func getStudentsLocations(studentKey: String, completion: @escaping ([Student]?, Error?) -> Void) {
       
        var request = URLRequest(url: URL(string: Constants.GetData.studentsLimit)!)

        if !studentKey.isEmpty {
            request = URLRequest(url: URL(string: Constants.GetData.oneStudent+studentKey)!)
        }
        let task = URLSession.shared.dataTask(with: request) {data ,response ,error in
            if error != nil {
                completion(nil, error)
            }else{
                if let data = data {
                    do {
                        let studentsLocations = try JSONDecoder().decode(Students.self, from: data)
                        completion(studentsLocations.results, nil)
                    }catch let error {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func postUpdateStudentLocation(objectId: String, key: String,firstName: String,lastName: String,mapString: String , url: String ,lat: Double , lng:Double , completion: @escaping (Bool?,Error?) -> Void){
        var request = URLRequest(url: URL(string: Constants.GetData.students)!)
        request.httpMethod = "POST"

        if !objectId.isEmpty {
            request = URLRequest(url: URL(string: Constants.GetData.students + "/" + objectId)!)
            request.httpMethod = "PUT"
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\",\"latitude\": \(lat), \"longitude\": \(lng)}".data(using: .utf8)
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(false,error)
                return
            }
            completion(true,nil)
        }
        task.resume()
    }
    
    

}
