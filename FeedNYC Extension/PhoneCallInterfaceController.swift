//
//  PhoneCallInterfaceController.swift
//  Feed NYC
//
//  Created by Cenker Demir on 9/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import WatchKit
import Foundation


class PhoneCallInterfaceController: WKInterfaceController {

    @IBOutlet var phoneNumberLabel: WKInterfaceLabel!
    var phoneNumberAsAString = "9735233822"
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        self.phoneNumberLabel.setText(self.phoneNumberAsAString)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @IBAction func callButtonTapped() {
        if let url = URL(string: "tel://\(self.phoneNumberAsAString)") {
            WKExtension.shared().openSystemURL(url)
            //WKApplication.sharedApplication().openURL(url)
        }
    }
    
    
}
