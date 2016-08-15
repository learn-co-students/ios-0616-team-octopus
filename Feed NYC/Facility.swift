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
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var fullAddress: String {return self.getFullAddress()}
    var distanceFromCurrentLocation = 1000.0
    
    // Should be in its own constructor call as convenience init (jsonDictionary: NSDictionary) ...
    class func makeFacility (jsonDictionary: NSDictionary) -> Facility {
        let newFacility = Facility()
        
        guard let
            name = jsonDictionary["name"] as? String,
            briefDescription = jsonDictionary["briefDescription"] as? String,
            streetAddress = jsonDictionary["streetAddress"] as? String,
            city = jsonDictionary["city"] as? String,
            state = jsonDictionary["state"] as? String,
            zipcode = jsonDictionary["zipcode"] as? String,
            phoneNumber = jsonDictionary["phoneNumber"] as? String,
            hoursOfOperation = jsonDictionary["hoursOfOperation"] as? String,
            intake = jsonDictionary["intake"] as? String,
            fee = jsonDictionary["fee"] as? String,
            featureList = jsonDictionary["featureList"] as? [String],
            eligibility = jsonDictionary["eligibility"] as? String,
            requiredDocuments = jsonDictionary["requiredDocuments"] as? String,
            latitude = jsonDictionary["latitude"] as? Double,
            longitude = jsonDictionary["longitude"] as? Double
        
            else { fatalError("Could not create repository object from supplied dictionary") }
        
        newFacility.name = name
        newFacility.briefDescription = briefDescription
        newFacility.streetAddress = streetAddress
        newFacility.city = city
        newFacility.state = state
        newFacility.zipcode = zipcode
        newFacility.phoneNumber = phoneNumber
        newFacility.hoursOfOperation = hoursOfOperation
        newFacility.intake = intake
        newFacility.fee = fee
        newFacility.featureList = featureList
        newFacility.eligibility = eligibility
        newFacility.requiredDocuments = requiredDocuments
        newFacility.latitude = latitude
        newFacility.longitude = longitude
        
        return newFacility
    }
    
    
    func toDictionary() -> [String: AnyObject] {
        var facilityAsDictionary = [String: AnyObject]()
        
        facilityAsDictionary["name"] = self.name
        facilityAsDictionary["briefDescription"] = self.briefDescription
        facilityAsDictionary["streetAddress"] = self.streetAddress
        facilityAsDictionary["city"] = self.city
        facilityAsDictionary["state"] = self.state
        facilityAsDictionary["zipcode"] = self.zipcode
        facilityAsDictionary["phoneNumber"] = self.phoneNumber
        facilityAsDictionary["hoursOfOperation"] = self.hoursOfOperation
        facilityAsDictionary["intake"] = self.intake
        facilityAsDictionary["fee"] = self.fee
        facilityAsDictionary["featureList"] = self.featureList
        facilityAsDictionary["eligibility"] = self.eligibility
        facilityAsDictionary["requiredDocuments"] = self.requiredDocuments
        facilityAsDictionary["latitude"] = self.latitude
        facilityAsDictionary["longitude"] = self.longitude
        
        return facilityAsDictionary
    }
    
    var description: String {
        return "name: \(name)\n, briefDescription: \(briefDescription)\n, streetAddress: \(streetAddress)\n, city: \(city)\n, state: \(state)\n, zipcode: \(zipcode)\n, phoneNumber: \(phoneNumber)\n, hoursOfOperation: \(hoursOfOperation)\n, intake: \(intake)\n, fee: \(fee)\n, featureList: \(featureList)\n, eligibility: \(eligibility)\n, requiredDocuments: \(requiredDocuments)\n, latitude: \(latitude)\n, longitude: \(longitude)\n, distance from the current location: \(distanceFromCurrentLocation)\n"
    }
    
    private func getFullAddress() -> String {
        return "\(self.streetAddress)+\(self.city)+\(self.state)+\(self.zipcode)"
    }
}
extension Facility {
    enum foodType: String {
        case FoodPantry = "Food Pantry"
        case SoupKitchen = "Soup Kitchen"
    }
}