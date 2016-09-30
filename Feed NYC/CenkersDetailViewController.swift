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
    
    @IBAction func addressTapped(_ sender: UIButton) {
        self.checkGoogleMapOnPhone()
    }
    
    @IBAction func phoneNumberTapped(_ sender: UIButton) {
        var phoneNumString = self.facilityToDisplay.phoneNumber.replacingOccurrences(of: " ", with: "")
        phoneNumString = phoneNumString.replacingOccurrences(of: "x", with: ",,,")
        if let url = URL(string: "tel://\(phoneNumString)") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func pageDone(_ sender: AnyObject) {
        super.dismiss(animated: true, completion: nil)
    }
    
    
    //updating labels
    func updateLabels() {
        self.facilityNameLabel.text = self.facilityToDisplay.name
        self.addressLabel.setTitle(self.createFullAddress(), for: UIControlState())
        let phoneNumWithExt = self.facilityToDisplay.phoneNumber.replacingOccurrences(of: " x", with: "  Ext:")
        self.phoneNumberLabel.setTitle(phoneNumWithExt, for: UIControlState())
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
    func getStringFromArray(_ array:[String])-> String {
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
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            self.showMapSelection()
        } else {
            self.openMapForPlace()
        }
    }
    
    func showMapSelection() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Directions", message: "Choose a Map Option!", preferredStyle: .actionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let googleMapsAction: UIAlertAction = UIAlertAction(title: "Google Maps", style: .default) { [weak weakSelf = self] action -> Void in
            //Code for launching Apple Maps goes here
            weakSelf?.openGoogleMapsAppWithDirection()
        }
        actionSheetController.addAction(googleMapsAction)
    
    
        let appleMapsAction: UIAlertAction = UIAlertAction(title: "Apple Maps", style: .default) { [weak weakSelf = self]  action -> Void in
            //Code for launching Apple Maps goes here
            weakSelf?.openMapForPlace()

        }
        actionSheetController.addAction(appleMapsAction)
    
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    
        
    
    }
    
    func dismissForGoogleMaps() {
        self.dismiss(animated: true, completion: {
            self.openGoogleMapsAppWithDirection()
        })
    }
    
    func dismissForAppleMaps() {
        self.dismiss(animated: true, completion: {
            self.openMapForPlace()
        })
    }
    
    //function to open Google's maps app
    func openGoogleMapsAppWithDirection() {
        let currentLatitude: CLLocationDegrees = store.currentLocationCoordinates.latitude
        let currentLongitude: CLLocationDegrees = store.currentLocationCoordinates.longitude
        let destinationLatitude:CLLocationDegrees = self.facilityToDisplay.latitude
        let destinationLongitude:CLLocationDegrees = self.facilityToDisplay.longitude
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let googleDirectionsString = "comgooglemaps://?saddr=\(currentLatitude),\(currentLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving&views=traffic"
            UIApplication.shared.openURL(URL(string: googleDirectionsString)!)
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
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ] as [String : Any]
        
        MKMapItem.openMaps(
            with: [myLocationMapItem, mapItem],
            launchOptions: launchOptions)
    }
    
    func textChameleonColor() {
        self.view.backgroundColor = UIColor.flatNavyBlueColorDark().lighten(byPercentage: 0.2)
        facilityNameLabel.textColor = UIColor.flatWhite()
        addressTitleLabel.textColor = UIColor.flatBlack()
        
        // Address button
        addressLabel.setTitleColor(UIColor.flatWhite(), for: UIControlState())
        addressLabel.backgroundColor = UIColor.flatNavyBlue().lighten(byPercentage: 0.1)
        addressLabel.layer.cornerRadius = 11.5
        phoneTitleLabel.textColor = UIColor.flatBlack()
        
        phoneNumberLabel.setTitleColor(UIColor.flatWhite(), for: UIControlState())
        phoneNumberLabel.backgroundColor = UIColor.flatNavyBlue().lighten(byPercentage: 0.1)
        phoneNumberLabel.layer.cornerRadius = 11.5
        
        hoursTitleLabel.textColor = UIColor.flatBlack()
        hoursLabel.textColor = UIColor.flatSkyBlueColorDark()
        intakeTitleLabel.textColor = UIColor.flatBlack()
        intakeLabel.textColor = UIColor.flatSkyBlueColorDark()
        feeTitleLabel.textColor = UIColor.flatBlack()
        feeLabel.textColor = UIColor.flatSkyBlueColorDark()
        featureTitleLabel.textColor = UIColor.flatBlack()
        featureListLabel.textColor = UIColor.flatSkyBlueColorDark()
        eligibilityTitleLabel.textColor = UIColor.flatBlack()
        eligibilityLabel.textColor = UIColor.flatSkyBlueColorDark()
        reqyiredDocTittleLabel.textColor = UIColor.flatBlack()
        requiredDocLabel.textColor = UIColor.flatSkyBlueColorDark()
        doneButton.setTitleColor(UIColor.flatSkyBlue(), for: UIControlState())


    }
    
}
