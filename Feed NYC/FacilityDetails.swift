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
    var city = String()
    var state = String()
    var zipCode = String()
    var fullAddress: String {return self.getFullAddress()}
    
    var description: String {
        return "name: \(name), briefDescription: \(briefDescription), streetAddress: \(streetAddress), phoneNumber: \(phoneNumber)"
    }
    
    private func getFullAddress() -> String {
        return "\(self.streetAddress)+\(self.city)+\(self.state)+\(self.zipCode)"
    }
    
    
}