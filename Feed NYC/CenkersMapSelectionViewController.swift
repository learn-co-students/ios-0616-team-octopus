//
//  CenkersMapSelectionViewController.swift
//  Feed NYC
//
//  Created by Cenker Demir on 8/11/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import MapKit

class CenkersMapSelectionViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func googleMapsTapped(sender: UIButton) {
        self.openGoogleMapsAppWithDirection()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func appleMapsTapped(sender: UIButton) {
        self.openMapForPlace()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //function to open Google's maps app
    func openGoogleMapsAppWithDirection() {
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?saddr=40.705329,-74.0139696&daddr=40.817330064,-73.8570632384&directionsmode=driving&views=traffic")!)
        } else {
            print("cannot open google maps app");
        }
        
    }

    // function to open Apple's maps app
    func openMapForPlace() {
        
        let currentLatitude: CLLocationDegrees = 40.705329
        let currentLongitude: CLLocationDegrees = -74.0139696
        let currentCoordinates = CLLocationCoordinate2DMake(currentLatitude, currentLongitude)
        
        let destinationLatitude:CLLocationDegrees =  40.817330064
        let destinationLongitude:CLLocationDegrees =  -73.8570632384
        let destinationCoordinates = CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude)
        
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(destinationCoordinates, regionDistance, regionDistance)
        
        let myLocationPlacemark = MKPlacemark(coordinate: currentCoordinates, addressDictionary: nil)
        let myLocationMapItem = MKMapItem(placemark: myLocationPlacemark)
        
        let placemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(parentViewController)"
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        MKMapItem.openMapsWithItems(
            [myLocationMapItem, mapItem],
            launchOptions: launchOptions)
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
