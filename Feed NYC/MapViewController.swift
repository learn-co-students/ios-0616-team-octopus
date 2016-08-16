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
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // view and manager to operate with map
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var marker: GMSMarker!
    
    var currentDeviceLocationLatitude = 0.0
    var currentDeviceLocationLongitude = 0.0
    // Whether we are authorized to use location
    
    // closest location to current location
    var closestFacility: Facility?
    var distanceInMetersForClosestFacility = 0.0
    
    // data store for all facility objects
    let store = FacilityDataStore.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.store.readInTextFile()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.createMapView()
        self.findClosestLocation()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // finds the closest facility to current user location
    // puts closest location to the propert "closestFacility" and the distance to it in "distanceInMetersForClosestFacility"
    func findClosestLocation() {
        
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
    
    func setupMarkers() {
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
    
    func createMapView() {
        
        let camera : GMSCameraPosition
        print (CLLocationManager.authorizationStatus())
        print (CLLocationManager.locationServicesEnabled())
        
        // .AuthorizedWhenInUse? = true
        if CLLocationManager.locationServicesEnabled() {
            // setting map with current location ≥coordinats in the middle
            camera = GMSCameraPosition.cameraWithLatitude(self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude, zoom: 13.0)

        }
        else {
            //if status == .Denied {
                camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 12.5)

            //  }
        }
        
        let smallerRect = CGRectMake(0, Constants.navBarHeight, self.view.bounds.width, self.view.bounds.height - Constants.navBarHeight)
        self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
        self.mapView.myLocationEnabled = true
        self.view.addSubview(mapView)
        self.view.sendSubviewToBack(mapView)
        //            self.view.insertSubview(mapView, atIndex: 0)
        // button in right low corner that makes current location in the middle
        self.mapView.settings.myLocationButton = true
        setupMarkers()
        self.view.subviews.forEach { view in
            print(view.frame.origin)
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
    
    func addBigRedButton() {
        var button = UIButton()
        //button.setTitle
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "closestLocSegue" {
            self.findClosestLocation()
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
            
            
            //calling the function that updates the singleton with current coordinates
            self.updateCurrentLocation()
        }
        if status == .Denied {
            // Let them know they need to allow location!
        }
        
        // if user denied access to his/he location coordinats or functionality is turned off
        // shows whole NYC map on screen
//        if status == .Denied {
//            let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 10.5)
//            let smallerRect = CGRectMake(0, Constants.navBarHeight, self.view.bounds.width, self.view.bounds.height - Constants.navBarHeight)
//            self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
//            self.mapView.myLocationEnabled = true
//            self.view.insertSubview(mapView, atIndex: 0)
//            setupMarkers()
//        }
        
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
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 14, bearing: 0, viewingAngle: 0)
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



