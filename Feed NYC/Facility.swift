//
//  Facility.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation


class Facility: CustomStringConvertible {
    
    var name = String()
    var briefDescription = String()
    var streetAddress = String()
    var city = String()
    var state = String()
    var zipcode = String()
    var phoneNumber = String()
    var hoursOfOperation = String()
    var intake = String()
    var fee = String()
    var featureList: [String] = []
    var eligibility = String()
    var requiredDocuments = String()
    var latitude: String?
    var longitude: String?
    
    
    var description: String {
        return "name: \(name)\n, briefDescription: \(briefDescription)\n, streetAddress: \(streetAddress)\n, city: \(city)\n, state: \(state)\n, zipcode: \(zipcode)\n, phoneNumber: \(phoneNumber)\n, hoursOfOperation: \(hoursOfOperation)\n, intake: \(intake)\n, fee: \(fee)\n, featureList: \(featureList)\n, eligibility: \(eligibility)\n, requiredDocuments: \(requiredDocuments)"
    }
}