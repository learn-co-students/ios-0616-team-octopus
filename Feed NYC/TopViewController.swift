//
//  TopViewController.swift
//  Feed NYC
//
//  Created by Henry Dinhofer on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GoogleMaps

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let geo = GeocodingAPI()
        geo.getGeoLatitudeLongtitudeByAddress()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        if let container = self.so_containerViewController
        {
            container.isSideViewControllerPresented = true
            
            // To close the sidebar menu set is sideVCPresented to false
        }

    }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
