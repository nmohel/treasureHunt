//
//  AddTreasuresVC.swift
//  TreasureHunt
//
//  Created by Nicole Ohel on 11/10/17.
//  Copyright © 2017 Nicole Ohel. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData

class AddTreasuresVC: UIViewController {
    var huntName:String?
    var thisHunt:Hunt?
    let locationManager = CLLocationManager()
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var mapSection: GMSMapView!
    @IBOutlet weak var huntNameLabel: UILabel!
    @IBOutlet weak var treasureNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        huntNameLabel.text = huntName
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func addTreasureButtonPressed(_ sender: UIButton) {
        if let name = treasureNameField.text {
            if name != "" {
                let currentPos = locationManager.location?.coordinate
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: currentPos!.latitude, longitude: currentPos!.longitude)
                marker.title = name
                marker.map = mapSection
                let treasure = NSEntityDescription.insertNewObject(forEntityName: "Treasure", into: context) as! Treasure
                treasure.name = name
                treasure.latitude = currentPos!.latitude
                treasure.longitude = currentPos!.longitude
                treasure.hunt = thisHunt
                appDel.saveContext()
                treasureNameField.text = ""
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}

extension AddTreasuresVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locCoordinate:CLLocationCoordinate2D? = manager.location?.coordinate
        
        if let coordinate = locCoordinate {
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 18.0)
            
            mapSection.camera = camera //Puts the map centered around your location
            
            print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
            
        }
        
        
    }
    
}

extension AddTreasuresVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

