//
//  Contants.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import Foundation

struct Constants{
    
    struct Auth {
    
        static let signUpURL = "https://auth.udacity.com/sign-up"
        static let loginURL = "https://onthemap-api.udacity.com/v1/session"
        static let publicData = "https://onthemap-api.udacity.com/v1/users/"
    }
    
    struct GetData {
        static let students = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let oneStudent = "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey="
        static let studentsLimit = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100"
    }
}
