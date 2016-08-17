//
//  CenkersDetailViewController.swift
//  Feed NYC
//
//  Created by Cenker Demir on 8/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CenkersDetailViewController: UIViewController {
    
    // shared datastore
    let store = FacilityDataStore.sharedInstance
    
    //facility object that we receive
    var facilityToDisplay: Facility = Facility()
    
    //label outlets
    @IBOutlet weak var facilityNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UIButton!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var intakeLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var featureListLabel: UILabel!
    @IBOutlet weak var eligibilityLabel: UILabel!
    @IBOutlet weak var requiredDocLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //call the function that updates the labels
        self.updateLabels()
        //print(facilityToDisplay)
        
        // fake facility coordinates for test - to be commented out and/or deleted later
//        facilityToDisplay.latitude = 40.817330064
//        facilityToDisplay.longitude = -73.8570632384
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addressTapped(sender: UIButton) {
        self.checkGoogleMapOnPhone()
    }
    
    @IBAction func phoneNumberTapped(sender: UIButton) {
        var phoneNumString = self.facilityToDisplay.phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        phoneNumString = phoneNumString.stringByReplacingOccurrencesOfString("x", withString: ",,,")
        if let url = NSURL(string: "tel://\(phoneNumString)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func pageDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //updating labels
    func updateLabels() {
        self.facilityNameLabel.text = self.facilityToDisplay.name
        self.addressLabel.setTitle(self.createAddress(), forState: .Normal)
        let phoneNumWithExt = self.facilityToDisplay.phoneNumber.stringByReplacingOccurrencesOfString(" x", withString: "  Ext:")
        self.phoneNumberLabel.setTitle(phoneNumWithExt, forState: .Normal)
        self.hoursLabel.text = self.facilityToDisplay.hoursOfOperation
        self.intakeLabel.text = self.facilityToDisplay.intake
        self.feeLabel.text = self.facilityToDisplay.fee
        self.featureListLabel.text = self.giveStringFromArray(self.facilityToDisplay.featureList)
        self.eligibilityLabel.text = self.facilityToDisplay.eligibility
        self.requiredDocLabel.text = self.facilityToDisplay.requiredDocuments
    }
    
    // a function to create the full address as a string to display
    func createAddress() -> String {
        var fullAddress = ""
        fullAddress = self.facilityToDisplay.streetAddress + "\n" + self.facilityToDisplay.city + ", " + self.facilityToDisplay.state + "  " + self.facilityToDisplay.zipcode
        return fullAddress
    }
    
    //getting the features list array as a string with spaces in between
    func giveStringFromArray(array:[String])-> String {
        var returnString = ""
        for i in 0..<array.count {
            returnString += array[i]
            if i != array.count-1 {
                returnString += " "
            }
        }
        return returnString
    }
    
    func checkGoogleMapOnPhone() {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            self.showMapAlert()
        } else {
            self.openMapForPlace()
        }
    }
    
    //function to open Google's maps app
    func openGoogleMapsAppWithDirection() {
        let currentLatitude: CLLocationDegrees = store.currentLocationCoordinates.latitude
        let currentLongitude: CLLocationDegrees = store.currentLocationCoordinates.longitude
        let destinationLatitude:CLLocationDegrees = self.facilityToDisplay.latitude
        let destinationLongitude:CLLocationDegrees = self.facilityToDisplay.longitude
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?saddr=\(currentLatitude),\(currentLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving&views=traffic")!)
        } else {
            print("cannot open google maps app");
        }
    }
    
    // function to open Apple's maps app
    func openMapForPlace() {
        let currentLatitude: CLLocationDegrees = store.currentLocationCoordinates.latitude
        let currentLongitude: CLLocationDegrees = store.currentLocationCoordinates.longitude
        let currentCoordinates = CLLocationCoordinate2DMake(currentLatitude, currentLongitude)
        
        let destinationLatitude:CLLocationDegrees = self.facilityToDisplay.latitude
        let destinationLongitude:CLLocationDegrees = self.facilityToDisplay.longitude
        let destinationCoordinates = CLLocationCoordinate2DMake(destinationLatitude, destinationLongitude)
        
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(destinationCoordinates, regionDistance, regionDistance)
        
        let myLocationPlacemark = MKPlacemark(coordinate: currentCoordinates, addressDictionary: nil)
        let myLocationMapItem = MKMapItem(placemark: myLocationPlacemark)
        myLocationMapItem.name = "Current Location"
        
        let placemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(self.facilityToDisplay.name)"
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        MKMapItem.openMapsWithItems(
            [myLocationMapItem, mapItem],
            launchOptions: launchOptions)
    }
    
    func showMapAlert() {
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
       
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
            //print("Cancel button tapped")
        })
        alertController.addAction(cancelAction)
        
        let googleButton = UIButton(frame: CGRectMake(20,10,260,30))
        googleButton.setTitle("Goggle Maps", forState: .Normal)
        googleButton.layer.cornerRadius = 3
        googleButton.setTitleColor(UIView().tintColor, forState: .Normal)
        googleButton.addTarget(self, action: #selector(dismissForGoogleMaps), forControlEvents: .TouchUpInside)
        alertController.view.addSubview(googleButton)
        
        let separator = UIButton(frame: CGRectMake(10,50,280, 0.5))
        separator.backgroundColor = UIColor.lightGrayColor()
        alertController.view.addSubview(separator)
        
        let appleButton = UIButton(frame: CGRectMake(20,60,260,30))
        appleButton.setTitle("Apple Maps", forState: .Normal)
        appleButton.layer.cornerRadius = 3
        appleButton.setTitleColor(UIView().tintColor, forState: .Normal)
        appleButton.addTarget(self, action: #selector(dismissForAppleMaps), forControlEvents: .TouchUpInside)
        alertController.view.addSubview(appleButton)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func dismissForGoogleMaps() {
        self.dismissViewControllerAnimated(true, completion: {
            self.openGoogleMapsAppWithDirection()
        })
    }
    
    func dismissForAppleMaps() {
        self.dismissViewControllerAnimated(true, completion: {
            self.openMapForPlace()
        })
    }
}
