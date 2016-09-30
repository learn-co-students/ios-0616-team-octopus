//
//  InterfaceController.swift
//  FeedNYC Extension
//
//  Created by Cenker Demir on 9/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import WatchKit
import Foundation
//import WatchConnectivity


class InterfaceController: WKInterfaceController {

    @IBOutlet var ClosestFacilityNameLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if activationState == .activated {
//            print("activated")
//        }
//    }
    
}
