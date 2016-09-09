//
//  InterfaceController.swift
//  FeedNYC Extension
//
//  Created by Cenker Demir on 9/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var ClosestFacilityNameLabel: WKInterfaceLabel!
    
    //create the Watch Connectivity Session on the Watch side
    var session : WCSession!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Initializing our Watch Connectivity session as a default session, set the delegate, and activate the session
        session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // get the user info from iOS
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        guard let nearestFacilityName = userInfo["nearestFacility"] as? String else {
            print("user info could not unwrapped")
            return
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.ClosestFacilityNameLabel.setText(nearestFacilityName)
            print("inside did recieve user info")
        }
    }

}
