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
    class func makeFacility (_ jsonDictionary: NSDictionary) -> Facility {
        let newFacility = Facility()
        
        guard let
            name = jsonDictionary["name"] as? String,
            let briefDescription = jsonDictionary["briefDescription"] as? String,
            let streetAddress = jsonDictionary["streetAddress"] as? String,
            let city = jsonDictionary["city"] as? String,
            let state = jsonDictionary["state"] as? String,
            let zipcode = jsonDictionary["zipcode"] as? String,
            let phoneNumber = jsonDictionary["phoneNumber"] as? String,
            let hoursOfOperation = jsonDictionary["hoursOfOperation"] as? String,
            let intake = jsonDictionary["intake"] as? String,
            let fee = jsonDictionary["fee"] as? String,
            let featureList = jsonDictionary["featureList"] as? [String],
            let eligibility = jsonDictionary["eligibility"] as? String,
            let requiredDocuments = jsonDictionary["requiredDocuments"] as? String,
            let latitude = jsonDictionary["latitude"] as? Double,
            let longitude = jsonDictionary["longitude"] as? Double
        
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
        
        facilityAsDictionary["name"] = self.name as AnyObject?
        facilityAsDictionary["briefDescription"] = self.briefDescription as AnyObject?
        facilityAsDictionary["streetAddress"] = self.streetAddress as AnyObject?
        facilityAsDictionary["city"] = self.city as AnyObject?
        facilityAsDictionary["state"] = self.state as AnyObject?
        facilityAsDictionary["zipcode"] = self.zipcode as AnyObject?
        facilityAsDictionary["phoneNumber"] = self.phoneNumber as AnyObject?
        facilityAsDictionary["hoursOfOperation"] = self.hoursOfOperation as AnyObject?
        facilityAsDictionary["intake"] = self.intake as AnyObject?
        facilityAsDictionary["fee"] = self.fee as AnyObject?
        facilityAsDictionary["featureList"] = self.featureList as AnyObject?
        facilityAsDictionary["eligibility"] = self.eligibility as AnyObject?
        facilityAsDictionary["requiredDocuments"] = self.requiredDocuments as AnyObject?
        facilityAsDictionary["latitude"] = self.latitude as AnyObject?
        facilityAsDictionary["longitude"] = self.longitude as AnyObject?
        
        return facilityAsDictionary
    }
    
    var description: String {
        return "name: \(name)\n, briefDescription: \(briefDescription)\n, streetAddress: \(streetAddress)\n, city: \(city)\n, state: \(state)\n, zipcode: \(zipcode)\n, phoneNumber: \(phoneNumber)\n, hoursOfOperation: \(hoursOfOperation)\n, intake: \(intake)\n, fee: \(fee)\n, featureList: \(featureList)\n, eligibility: \(eligibility)\n, requiredDocuments: \(requiredDocuments)\n, latitude: \(latitude)\n, longitude: \(longitude)\n, distance from the current location: \(distanceFromCurrentLocation)\n"
    }
    
    fileprivate func getFullAddress() -> String {
        return "\(self.streetAddress)+\(self.city)+\(self.state)+\(self.zipcode)"
    }
}
extension Facility {
    enum foodType: String {
        case FoodPantry = "Food Pantry"
        case SoupKitchen = "Soup Kitchen"
    }
}
