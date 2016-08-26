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
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UIButton!
    @IBOutlet weak var hoursTitleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var intakeTitleLabel: UILabel!
    @IBOutlet weak var intakeLabel: UILabel!
    @IBOutlet weak var feeTitleLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var featureTitleLabel: UILabel!
    @IBOutlet weak var featureListLabel: UILabel!
    @IBOutlet weak var eligibilityTitleLabel: UILabel!
    @IBOutlet weak var eligibilityLabel: UILabel!
    @IBOutlet weak var reqyiredDocTittleLabel: UILabel!
    @IBOutlet weak var requiredDocLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call the function that updates the labels
        self.updateLabels()
        
        self.textChameleonColor()
        
//        print (facilityToDisplay)
        
        
//        addressLabel.titleLabel?.minimumScaleFactor = 0.5
//        addressLabel.titleLabel?.numberOfLines = 0
//        addressLabel.titleLabel?.adjustsFontSizeToFitWidth = true
//        hoursLabel.adjustsFontSizeToFitWidth = true
//        eligibilityLabel.adjustsFontSizeToFitWidth = true
//        eligibilityTitleLabel.adjustsFontSizeToFitWidth = true
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
        super.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //updating labels
    func updateLabels() {
        self.facilityNameLabel.text = self.facilityToDisplay.name
        self.addressLabel.setTitle(self.createFullAddress(), forState: .Normal)
        let phoneNumWithExt = self.facilityToDisplay.phoneNumber.stringByReplacingOccurrencesOfString(" x", withString: "  Ext:")
        self.phoneNumberLabel.setTitle(phoneNumWithExt, forState: .Normal)
        self.hoursLabel.text = self.facilityToDisplay.hoursOfOperation
        self.intakeLabel.text = self.facilityToDisplay.intake
        self.feeLabel.text = self.facilityToDisplay.fee
        self.featureListLabel.text = self.getStringFromArray(self.facilityToDisplay.featureList)
        self.eligibilityLabel.text = self.facilityToDisplay.eligibility
        self.requiredDocLabel.text = self.facilityToDisplay.requiredDocuments
    }
    
    // a function to create the full address as a string to display
    func createFullAddress() -> String {
        var fullAddress = ""
        fullAddress = self.facilityToDisplay.streetAddress + "\n" + self.facilityToDisplay.city + ", " + self.facilityToDisplay.state + "  " + self.facilityToDisplay.zipcode
        return fullAddress
    }
    
    //getting the features list array as a string with spaces in between
    func getStringFromArray(array:[String])-> String {
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
            self.showMapSelection()
        } else {
            self.openMapForPlace()
        }
    }
    
    func showMapSelection() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Directions", message: "Choose a Map Option!", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let googleMapsAction: UIAlertAction = UIAlertAction(title: "Google Maps", style: .Default) { [weak weakSelf = self] action -> Void in
            //Code for launching Apple Maps goes here
            weakSelf?.openGoogleMapsAppWithDirection()
        }
        actionSheetController.addAction(googleMapsAction)
    
    
        let appleMapsAction: UIAlertAction = UIAlertAction(title: "Apple Maps", style: .Default) { [weak weakSelf = self]  action -> Void in
            //Code for launching Apple Maps goes here
            weakSelf?.openMapForPlace()

        }
        actionSheetController.addAction(appleMapsAction)
    
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    
        
    
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
    
    //function to open Google's maps app
    func openGoogleMapsAppWithDirection() {
        let currentLatitude: CLLocationDegrees = store.currentLocationCoordinates.latitude
        let currentLongitude: CLLocationDegrees = store.currentLocationCoordinates.longitude
        let destinationLatitude:CLLocationDegrees = self.facilityToDisplay.latitude
        let destinationLongitude:CLLocationDegrees = self.facilityToDisplay.longitude
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            let googleDirectionsString = "comgooglemaps://?saddr=\(currentLatitude),\(currentLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving&views=traffic"
            UIApplication.sharedApplication().openURL(NSURL(string: googleDirectionsString)!)
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
    
    func textChameleonColor() {
        self.view.backgroundColor = UIColor.flatNavyBlueColorDark().lightenByPercentage(0.2)
        facilityNameLabel.textColor = UIColor.flatWhiteColor()
        addressTitleLabel.textColor = UIColor.flatBlackColor()
        
        // Address button
        addressLabel.setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
        addressLabel.backgroundColor = UIColor.flatNavyBlueColor().lightenByPercentage(0.1)
        addressLabel.layer.cornerRadius = 11.5
        phoneTitleLabel.textColor = UIColor.flatBlackColor()
        
        phoneNumberLabel.setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
        phoneNumberLabel.backgroundColor = UIColor.flatNavyBlueColor().lightenByPercentage(0.1)
        phoneNumberLabel.layer.cornerRadius = 11.5
        
        hoursTitleLabel.textColor = UIColor.flatBlackColor()
        hoursLabel.textColor = UIColor.flatSkyBlueColorDark()
        intakeTitleLabel.textColor = UIColor.flatBlackColor()
        intakeLabel.textColor = UIColor.flatSkyBlueColorDark()
        feeTitleLabel.textColor = UIColor.flatBlackColor()
        feeLabel.textColor = UIColor.flatSkyBlueColorDark()
        featureTitleLabel.textColor = UIColor.flatBlackColor()
        featureListLabel.textColor = UIColor.flatSkyBlueColorDark()
        eligibilityTitleLabel.textColor = UIColor.flatBlackColor()
        eligibilityLabel.textColor = UIColor.flatSkyBlueColorDark()
        reqyiredDocTittleLabel.textColor = UIColor.flatBlackColor()
        requiredDocLabel.textColor = UIColor.flatSkyBlueColorDark()
        doneButton.setTitleColor(UIColor.flatSkyBlueColor(), forState: .Normal)


    }
    
}
