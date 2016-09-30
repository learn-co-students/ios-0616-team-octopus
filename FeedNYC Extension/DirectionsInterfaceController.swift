//
//  DirectionsInterfaceController.swift
//  Feed NYC
//
//  Created by Cenker Demir on 9/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import WatchKit
import Foundation
//import MapKit

class DirectionsInterfaceController: WKInterfaceController {

    @IBOutlet var mapObject: WKInterfaceMap!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let location = CLLocationCoordinate2D(latitude: 40, longitude: -73)
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        
        mapObject.addAnnotation(location, with: WKInterfaceMapPinColor.purple)
        
        mapObject.setRegion(MKCoordinateRegion(center: location, span: coordinateSpan))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
}
