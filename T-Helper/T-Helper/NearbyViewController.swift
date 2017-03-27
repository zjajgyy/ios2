//
//  NearbyViewController.swift
//  T-Helper
//
//  Created by zjajgyy on 2016/11/30.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearbyViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var annotation: POIAnnotation!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressTextField: UITextField!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var position: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let status = CLLocationManager.authorizationStatus()
        if status == .restricted || status == .denied {
            print("location service is denied!")
        } else {
            if status == .notDetermined {
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            } else {
                startLocationService()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func getCurLocation(_ sender: Any) {
//        let status = CLLocationManager.authorizationStatus()
//        if status == .restricted || status == .denied {
//            print("location service is denied!")
//        } else {
//            if status == .notDetermined {
//                locationManager.delegate = self
//                locationManager.requestWhenInUseAuthorization()
//            } else {
//                startLocationService()
//            }
//        }
//    }
    
    @IBAction func setPositionAction(_ sender: Any) {
        //self.position = addressTextField.text
        //print("qqqqqqq:"+self.position)
        //performSegue(withIdentifier: "SetPosition", sender: self)
    }
    
    func startLocationService() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationService() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        if (error as NSError).code != CLError.locationUnknown.rawValue {
            stopLocationService()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        if newLocation.timestamp.timeIntervalSinceNow < -5 && newLocation.horizontalAccuracy<0 {
            return
        }
        print("We are Done!")
        findGeoInfo(newLocation)
        stopLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startLocationService()
        } else {
            stopLocationService()
        }
    }
    
    func findGeoInfo(_ location: CLLocation) {
        print("***Going to geocode")
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {[weak self]
            placemarks, error in
            if let error = error {
                print("fail with error: \(error)")
            } else if let placemark = placemarks?.last! {
                self?.addressTextField.text = self?.getAddress(from: placemark)
                if let mapAddress = self?.getAddress(from: placemark) {
                    self!.showOnMap(mapAddress)
                }
                
            } else {
                print("no address found")
            }
        })
        
    }
    
    func getAddress(from placemark: CLPlacemark?) -> String {
        var address = ""
        
        if let s = placemark?.subThoroughfare {
            address += s + ""
        }
        if let s = placemark?.thoroughfare {
            address += s
        }
        address += "\n"
        
        /*if let s = placemark?.locality {
            address += s + ""
        }
        if let s = placemark?.administrativeArea {
            address += s + ""
        }
        if let s = placemark?.postalCode {
            address += s
        }*/
        
        return address
    }
    
    
    func showOnMap(_ address: String){
        
        if annotation != nil {
            self.mapView.removeAnnotation(annotation)
            annotation = nil
        }
        
        print(address)
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = address
        searchRequest.region = self.mapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start{ response, error in
            guard let response = response, error == nil else {
                print("There was an error searching for: \(searchRequest.naturalLanguageQuery) error: \(error)")
                return
            }
//            for mapItem in response.mapItems {
//                print("item: " + mapItem.name!)
//                if let coordinate = mapItem.placemark.location?.coordinate {
//                    let annotation = POIAnnotation(coordinate: coordinate, title: mapItem.name, subtitle: mapItem.placemark.thoroughfare, placemark: mapItem.placemark)
//                    self.annotation = annotation
//                }
//            }
            let mapItem = response.mapItems[0]
            if let coordinate = mapItem.placemark.location?.coordinate {
                let annotation = POIAnnotation(coordinate: coordinate, title: mapItem.name, subtitle: mapItem.placemark.thoroughfare, placemark: mapItem.placemark)
                self.annotation = annotation
            }
            
            self.mapView.addAnnotation(self.annotation)
        }
    }
}

