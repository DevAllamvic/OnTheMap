//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Osama Allam on 7/12/19.
//  Copyright © 2019 Osama Allam. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController ,MKMapViewDelegate{

    var annotations: [MKPointAnnotation] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    var Key: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Key = UserDefaults.standard.string(forKey: "user_key")!
        
        getLocations()
    }
    
    
    func getLocations (){
        StudentsClient().getStudentsLocations(studentKey: "") { locationList, error  in
            DispatchQueue.main.async {
                if error != nil {
                    AlertHelper.showMessage(view: self, title: "Error", error: error!.localizedDescription)
                } else {
                    self.annotations.removeAll()
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    for location in locationList ?? [] {
                        let lat = CLLocationDegrees(location.latitude)
                        let lng = CLLocationDegrees(location.longitude)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        let first = location.firstName
                        let last = location.lastName
                        let url = location.mediaURL
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(String(describing: first )) \(String(describing: last ))"
                        annotation.subtitle = url
                        self.annotations.append(annotation)
                        self.mapView.addAnnotations(self.annotations)
                        self.mapView.reloadInputViews()
                        
                    }
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
    
    @IBAction func refreshButton(_ sender: Any) {
        getLocations()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let locationURLString = view.annotation?.subtitle!
            let url = URL(string: locationURLString!)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                AlertHelper.showMessage(view: self, title: "Error", error: "Invalid URL")
            }
        }
    }

}
