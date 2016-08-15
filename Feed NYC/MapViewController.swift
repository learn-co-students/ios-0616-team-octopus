//
//  ViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    // view and manager to operate with map
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    
    var currentDeviceLocationLatitude = 0.0
    var currentDeviceLocationLongitude = 0.0
    
    // closest location to current location
    var closestFacility: Facility?
    var distanceInMetersForClosestFacility = 0.0
    
    // data store for all facility objects
    let store = FacilityDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let geo = GeocodingAPI()
//        geo.getGeoLatitudeLongtitudeByAddress()
        let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 10.5)
        
        let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
        self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
        self.mapView.myLocationEnabled = true
        self.view.insertSubview(mapView, atIndex: 0)
        
        
        self.setUpMaps()

        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()

        
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
        for i in 0...10 {
            let location = CLLocation.init(latitude: self.store.facilities[i].latitude, longitude: self.store.facilities[i].longitude)
            distanceInMeters = currentLocation.distanceFromLocation(location)
            if minDistance > distanceInMeters {
                minDistance = distanceInMeters
                self.closestFacility = self.store.facilities[i]
                self.distanceInMetersForClosestFacility = minDistance
            }
        }
    }
    
    func setUpMaps() {
        // map possition at start

        // TEMP test markers
        // Marker Green
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 40.723074, longitude: -73.986348)
        marker.title = "Test"
        marker.snippet = "test"
        marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        marker.map = mapView
        // Marker Blue
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 40.717540, longitude: -74.001620)
        marker1.title = "Test"
        marker1.snippet = "test"
        marker1.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        marker1.map = mapView
        
        // rendering markers on the map
        for i in 0...10 {
            let currentFasility = self.store.facilities[i]

            
            
            //print("CURRENT FACILITY: \(currentFasility)")
            


            let latitude = currentFasility.latitude
            let longitude = currentFasility.longitude
            let name = currentFasility.name
          
            let position = CLLocationCoordinate2DMake(latitude, longitude)
            let marker = GMSMarker(position: position)
            marker.title = name
            marker.map = mapView
           
        }        
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        if let container = self.so_containerViewController
        {
            container.isSideViewControllerPresented = true
            
            // To close the sidebar menu set is sideVCPresented to false
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
            
            self.currentDeviceLocationLatitude = manager.location!.coordinate.latitude
            self.currentDeviceLocationLongitude = manager.location!.coordinate.longitude
            
            self.findClosestLocatio()
            
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
    
    // this function moves blue marker on the map with user movement,
    // constantly updating new user location and move map accordingly, so blue marker always in the middle of the view
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
}


