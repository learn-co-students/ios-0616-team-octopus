//
//  ViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    
    override func loadView() {
        // map possition at start
        let camera = GMSCameraPosition.cameraWithLatitude(40.723074, longitude: -73.986348, zoom: 11.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        // Marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 40.723074, longitude: -73.986348)
        marker.title = "Test"
        marker.snippet = "test"
        marker.map = mapView
    }


}

