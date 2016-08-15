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
    
    let locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    var currentDeviceLocationLatitude = 0.0
    var currentDeviceLocationLongitude = 0.0
    
    let store = FacilityDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store.readInTextFile()
        setUpMaps()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//
//        if status == .AuthorizedWhenInUse {
//            
//            locationManager.startUpdatingLocation()
//            
//            self.mapView.myLocationEnabled = true
//            self.mapView.settings.myLocationButton = true
//        }
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            
//            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 18, bearing: 0, viewingAngle: 0)
//            
//            locationManager.stopUpdatingLocation()
//        }
//    }
    
    func setUpMaps() {
        // map possition at start
        let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 10.5)
        let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
        self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
        self.mapView.myLocationEnabled = true
        self.view.insertSubview(mapView, atIndex: 0)


        //        self.view.addSubview(mapView)
        //        view = mapView
        //        self.view.bringSubviewToFront(mapView)
        
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
        
        

        // MARK: -To display all the pins on map
        for i in 0..<self.store.facilities.count {
            let currentFasility = self.store.facilities[i]
            
            
            
            print("CURRENT FACILITY: \(currentFasility)")
            


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
//1
extension MapViewController {
    
    // 2 authorization status for the application (can I get access to your location?)
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 3
        
        
        // if user aggried access to his/he location coordinats
        if status == .AuthorizedWhenInUse {
        
            // 4
            locationManager.startUpdatingLocation()
            
            // current user location latitude and longitude
            self.currentDeviceLocationLatitude = manager.location!.coordinate.latitude
            self.currentDeviceLocationLongitude = manager.location!.coordinate.longitude
            
            // setting map with current location coordinats in the middle
            // zoom will be changable to represent some markers
            let camera = GMSCameraPosition.cameraWithLatitude(self.currentDeviceLocationLatitude, longitude: self.currentDeviceLocationLongitude, zoom: 13.0)
            let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
            self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
            self.view.insertSubview(mapView, atIndex: 0)
            self.mapView.myLocationEnabled = true
            
            // button in right low corner that makes curren location in the middle
            self.mapView.settings.myLocationButton = true
        }
        
        
        // if user denied access to his/he location coordinats or functionality is turned off
        if status == .Denied {
            let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 10.5)
            let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
            self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
            self.mapView.myLocationEnabled = true
            self.view.insertSubview(mapView, atIndex: 0)
        }
        
    }
    
    // 6
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    
}


