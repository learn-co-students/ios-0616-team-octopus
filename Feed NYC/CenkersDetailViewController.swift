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
        facilityToDisplay.name = "Flatiron Soup Kitchen and Food Pantry"
        facilityToDisplay.streetAddress = "440 blah blah ave."
        facilityToDisplay.city = "Bronx"
        facilityToDisplay.state = "NY"
        facilityToDisplay.zipcode = "100123"
        facilityToDisplay.phoneNumber = "(718) 773-3551 x152"
        facilityToDisplay.hoursOfOperation = "10:00AM - 5:00PM"
        facilityToDisplay.intake = "intake done"
        facilityToDisplay.fee = "Free"
        facilityToDisplay.featureList = ["soup kitchen", "food pantry"]
        facilityToDisplay.eligibility = "open for everyone"
        facilityToDisplay.requiredDocuments = "please call"
        
        //call the function that updates the labels
        self.updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addressTapped(sender: UIButton) {
        
    }
    
    @IBAction func phoneNumberTapped(sender: UIButton) {
        var phoneNumString = self.facilityToDisplay.phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        phoneNumString = phoneNumString.stringByReplacingOccurrencesOfString("x", withString: ",,,")
        if let url = NSURL(string: "tel://\(phoneNumString)") {
            UIApplication.sharedApplication().openURL(url)
        }
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
    
//    // function to open the maps app
//    func openMapForPlace() {
//        
////        let lat1 : NSString = self.venueLat
////        let lng1 : NSString = self.venueLng
//        
//        let latitute:CLLocationDegrees =  40.817330064
//        let longitute:CLLocationDegrees =  -73.8570632384
//        
//        let regionDistance:CLLocationDistance = 10000
//        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
//        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
//        let options = [
//            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
//            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
//        ]
//        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = "\(self.venueName)"
//        mapItem.openInMapsWithLaunchOptions(options)
//        
//    }
}
