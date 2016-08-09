//
//  ViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    
    override func loadView() {
        // map possition at start
        let camera = GMSCameraPosition.cameraWithLatitude(40.738440, longitude: -73.950498, zoom: 11.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
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
    }


}

