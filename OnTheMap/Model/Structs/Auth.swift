//
//  Auth.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let user: User?
}

struct User: Codable {
    let firstName: String?
    let lastName: String?
}

struct Auth: Codable {
    let account: Account?
    let session: Session?
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}
