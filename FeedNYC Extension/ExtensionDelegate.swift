//
//  ExtensionDelegate.swift
//  FeedNYC Extension
//
//  Created by Cenker Demir on 9/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    //create the Watch Connectivity Session on the Watch side
    var session : WCSession!
    
    var facilityInfo = ""
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        // Initializing our Watch Connectivity session as a default session, set the delegate, and activate the session
        session = WCSession.default()
        session.delegate = self
        session.activate()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("activated")
        }
    }
    
    // get the user info from iOS
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        guard let nearestFacilityName = userInfo["nearestFacility"] as? String else {
            print("user info could not unwrapped")
            return
        }
        DispatchQueue.main.async {
            self.facilityInfo = nearestFacilityName
            print("inside did recieve user info: \(self.facilityInfo)")
        }
    }
}
