//
//  ViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    // view and manager to operate with map
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var marker: GMSMarker!
    
    var currentDeviceLocationLatitude = 0.0
    var currentDeviceLocationLongitude = 0.0
    
    // closest location to current location
    var closestFacility: Facility?
    var distanceInMetersForClosestFacility = 0.0
    
    // data store for all facility objects
    let store = FacilityDataStore.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 10.5)
        //
        //        let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
        //        self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
        //        self.mapView.myLocationEnabled = true
        //        self.view.insertSubview(mapView, atIndex: 0)
        
        self.store.readInTextFile()
        setUpMaps()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // finds the closest facility to current user location
    // puts closest location to the propert "closestFacility" and the distance to it in "distanceInMetersForClosestFacility"
    func findClosestLocatio() {
        
        let currentLocation: CLLocation = CLLocation.init(latitude: self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude)
        var minDistance: Double = 1000000.0
        var distanceInMeters = 0.0
        // go through all locations and find the closest one
        for i in 0..<store.facilities.count {
            let location = CLLocation.init(latitude: self.store.facilities[i].latitude, longitude: self.store.facilities[i].longitude)
            distanceInMeters = currentLocation.distanceFromLocation(location)
            if minDistance > distanceInMeters {
                minDistance = distanceInMeters
                self.closestFacility = self.store.facilities[i]
                self.distanceInMetersForClosestFacility = minDistance
            }
            self.store.facilities[i].distanceFromCurrentLocation = distanceInMeters * 0.000621371
        }
    }
    
    func setUpMaps() {
        // map possition at start
        let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 10.5)
        let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
        self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
        self.mapView.myLocationEnabled = true
        self.view.insertSubview(mapView, atIndex: 0)
        
        // MARK: -To display all the pins on map
        for i in 0..<self.store.facilities.count {
            let currentFacility = self.store.facilities[i]
            
            
            let latitude = currentFacility.latitude
            let longitude = currentFacility.longitude
            let name = currentFacility.name
            
            let position = CLLocationCoordinate2DMake(latitude, longitude)
            let marker = GMSMarker(position: position)
            marker.title = name
            marker.map = mapView
        }
    }
    

//    // because the current location is a property, we can find each location's distance to the current location
//    func findDistanceOfFacility(destLat: CLLocationDegrees, destLong: CLLocationDegrees) -> Double {
//        let sourceLocation : CLLocation = CLLocation(latitude: currentDeviceLocationLatitude, longitude: currentDeviceLocationLongitude)
//        let destinationLocation: CLLocation = CLLocation(latitude: destLat, longitude: destLong)
//        //calculate and convert to miles
//        let distance = destinationLocation.distanceFromLocation(sourceLocation) * 0.000621371
//        
//        return distance
//    }
//    
//    // update disctances
//    func updateDistanceForLocations() {
//        for i in 0..<self.store.facilities.count {
//            let currentFacility = self.store.facilities[i]
//            currentFacility.distanceFromCurrentLocation = self.findDistanceOfFacility(currentFacility.latitude, destLong: currentFacility.longitude)
//        }
//
//    }

    
    @IBAction func showMenu(sender: AnyObject) {
        if let container = self.so_containerViewController
        {
            container.isSideViewControllerPresented = true
            
            // To close the sidebar menu set is sideVCPresented to false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "closestLocSegue" {
            self.findClosestLocatio()
            let destVC = segue.destinationViewController as! CenkersDetailViewController
            if let closestFacility = self.closestFacility {
                destVC.facilityToDisplay = closestFacility
            }
            else {
                print("could not unwrap the closest facility")
            }
        }
    }
}


// MARK: - CLLocationManagerDelegate

extension MapViewController {
    
    // 2 authorization status for the application (can I get access to your location?)
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
        // if user aggried access to his/he location coordinats
        if status == .AuthorizedWhenInUse {
            
            // ask for updates on the user’s location
            locationManager.startUpdatingLocation()
                
                // current user location latitude and longitude
            if let managerLocation = manager.location {
                self.currentDeviceLocationLatitude = managerLocation.coordinate.latitude
                self.currentDeviceLocationLongitude = managerLocation.coordinate.longitude
            }

            self.findClosestLocatio()
            
            //calling the function that updates the singleton with current coordinates
            self.updateCurrentLocation()
            
            // setting map with current location coordinats in the middle
            let camera = GMSCameraPosition.cameraWithLatitude(self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude, zoom: 13.0)
            let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
            self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
            self.view.insertSubview(mapView, atIndex: 0)
            self.mapView.myLocationEnabled = true
            // button in right low corner that makes curren location in the middle
            self.mapView.settings.myLocationButton = true
        }
        
        
        // if user denied access to his/he location coordinats or functionality is turned off
        // shows whole NYC map on screen
        if status == .Denied {
            let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 10.5)
            let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
            self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
            self.mapView.myLocationEnabled = true
            self.view.insertSubview(mapView, atIndex: 0)
        }
        
    }
    
    //function to set the current coordinates to singleton's (datastore) currenLocationCoordinates property
    func updateCurrentLocation() {
        let currentCoordinates = CLLocationCoordinate2D(latitude: self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude)
        
        store.currentLocationCoordinates = currentCoordinates
    }
    
    // this function moves blue marker on the map with user movement,
    // constantly updating new user location and move map accordingly, so blue marker always in the middle of the view
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}

//    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
//
//        let placeMarker = marker as! XibAnnotationView
//
//        if let infoView = UIView.viewFromNibName("XibAnnotationView") as? XibAnnotationView {
//
//            infoView.locationLabel.text = placeMarker.locationName
//
//            return infoView
//        } else {
//            return nil
//        }
//    }
//}


//    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
//
////
////        let placemarker = marker as! JohannView
////
////        var newView:UIView{
////            var nView = UIView()
////            nView.backgroundColor = UIColor.blueColor()
////            return nView
////        }
//
////        let coordinateString = "\(coordinate.latitude) \(coordinate.longitude)"
////        let currentFacility = self.store.facilitiesDictionary[coordinateString]
////        print(currentFacility)
//
//        return

//        let placeMarker = marker as! XibAnnotationView

//
//    }



