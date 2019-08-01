//
//  Student.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import Foundation


struct Students: Codable {
    let results: [Student]?
}

struct Student : Codable {
    var uniqueKey: String
    var objectId: String
    var firstName: String
    var lastName: String
    var longitude: Double
    var latitude: Double
    var mediaURL: String
}
