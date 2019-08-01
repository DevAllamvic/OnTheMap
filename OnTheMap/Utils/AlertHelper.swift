//
//  AlertHelper.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    static func showMessage(view: UIViewController,title: String , error: String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(alert,animated: true, completion: nil)
    }
    
}
