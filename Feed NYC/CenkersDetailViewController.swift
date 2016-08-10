//
//  CenkersDetailViewController.swift
//  Feed NYC
//
//  Created by Cenker Demir on 8/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CenkersDetailViewController: UIViewController {
    
    //facility object that we receive
    var facilityToDisplay: Facility = Facility()
    
    //label outlets
    @IBOutlet weak var briefDescLabel: UILabel!
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
        
        facilityToDisplay.briefDescription = "food pantry"
        facilityToDisplay.streetAddress = "440 blah blah ave."
        facilityToDisplay.city = "Bronx"
        facilityToDisplay.state = "NY"
        facilityToDisplay.zipcode = "100123"
        facilityToDisplay.phoneNumber = "(917) 604-4812 x152"
        facilityToDisplay.intake = "intake done"
        facilityToDisplay.fee = "Free"
        facilityToDisplay.featureList = ["soup kitchen", "food pantry"]
        facilityToDisplay.eligibility = "open for everyone"
        facilityToDisplay.requiredDocuments = "please call"
        
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
        self.briefDescLabel.text = self.facilityToDisplay.briefDescription
        self.addressLabel.setTitle(self.createAddress(), forState: .Normal)
        self.phoneNumberLabel.setTitle(self.facilityToDisplay.phoneNumber, forState: .Normal)
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
}
