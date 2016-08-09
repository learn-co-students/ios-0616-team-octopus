//
//  FacilityDetails.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation


class FacilityDetails: CustomStringConvertible {
    
    var name = String()
    var briefDescription = String()
    var streetAddress = String()
    var phoneNumber = String()
    
    var description: String {
        return "name: \(name), briefDescription: \(briefDescription), streetAddress: \(streetAddress), phoneNumber: \(phoneNumber)"
    }
}