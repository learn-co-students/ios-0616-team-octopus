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
    
    let store = FacilityDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geo = GeocodingAPI()
        geo.getGeoLatitudeLongtitudeByAddress()
        setUpMaps()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            self.mapView.myLocationEnabled = true
            self.mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 18, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func setUpMaps() {
        // map possition at start
        
        let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 11.0)
        
        let smallerRect = CGRectMake(0, 75, self.view.bounds.width, self.view.bounds.height - 75)
        self.mapView = GMSMapView.mapWithFrame(smallerRect, camera: camera)
        mapView.myLocationEnabled = true
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
        
        
        for i in 0...1 {
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


