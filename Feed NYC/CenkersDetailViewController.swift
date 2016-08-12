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
        
        // fake facility for test - to be commented out and/or deleted later
//        facilityToDisplay.name = "Holy Cross Church"
//        facilityToDisplay.streetAddress = "600 Southview ave."
//        facilityToDisplay.city = "Bronx"
//        facilityToDisplay.state = "NY"
//        facilityToDisplay.zipcode = "100123"
//        facilityToDisplay.phoneNumber = "(718) 773-3551 x152"
//        facilityToDisplay.hoursOfOperation = "10:00AM - 5:00PM"
//        facilityToDisplay.intake = "please call"
//        facilityToDisplay.fee = "Free"
//        facilityToDisplay.featureList = ["soup kitchen", "food pantry"]
//        facilityToDisplay.eligibility = "open for everyone"
//        facilityToDisplay.requiredDocuments = "please call"
        
        //call the function that updates the labels
        self.updateLabels()
        print(facilityToDisplay)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addressTapped(sender: UIButton) {
        self.openGoogleMapsAppWithDirection()
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
    
    //function to open Google's maps app
    func openGoogleMapsAppWithDirection() {
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                "comgooglemaps://?saddr=40.705329,-74.0139696&daddr=40.817330064,-73.8570632384&directionsmode=driving&views=traffic")!)
        } else {
            self.openMapForPlace()
            //print("cannot open google maps app");
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
        mapItem.name = "\(self.facilityToDisplay.name)"
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        MKMapItem.openMapsWithItems(
            [myLocationMapItem, mapItem],
            launchOptions: launchOptions)
    }
    

}
