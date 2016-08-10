//
//  FacilityDataStore.swift
//  Feed NYC
//
//  Created by Henry Dinhofer on 8/10/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class FacilityDataStore {
    static let sharedInstance = FacilityDataStore()
    private init() {}
    
    var facilities : [Facility] = []
    
    func refreshFacilitiesDataStoreWithCompletion(completion: () -> ()) {
        facilities.removeAll()
        FacilityParser.getFacilitiesWithCompletion { (parsedFacilities) in
            self.cleanRedundantFacilities(parsedFacilities, completion: { (cleanedFacilities) in
                self.facilities = cleanedFacilities
                print(self.facilities[20])
                completion()
            })
        }
    }
    
    func cleanRedundantFacilities(parsedFacilities: [Facility], completion: ([Facility])->()) {
        var i=0
        var cleanedFacilities: [Facility] = []
        while i < parsedFacilities.count-1 {
            if parsedFacilities[i].streetAddress == parsedFacilities[i+1].streetAddress {
                parsedFacilities[i].featureList.appendContentsOf(parsedFacilities[i+1].featureList)
                parsedFacilities[i].briefDescription = parsedFacilities[i].briefDescription + " " + parsedFacilities[i+1].briefDescription
                cleanedFacilities.append(parsedFacilities[i])
                i += 1
            }
            else {
                cleanedFacilities.append(parsedFacilities[i])
            }
            i += 1
        }
        if parsedFacilities[parsedFacilities.count-1].streetAddress != parsedFacilities[parsedFacilities.count-2].streetAddress {
            cleanedFacilities.append(parsedFacilities[parsedFacilities.count-1])
        }
        completion(cleanedFacilities)
    }
    
    
    // featureToCompare is either "Soup Kitchen" or "Food Pantry"
    //    Method example call: self.store.getFacilitiesThatHave(feature: Facility.foodType.FoodPantry)
    func getFacilitiesThatHave(feature featureToCompare: Facility.foodType) -> [Facility]{
        var facilityList = [Facility]()
        
        for facility in self.facilities {
            for feature in facility.featureList {
                if feature == featureToCompare.rawValue {
                    facilityList.append(facility)
                    break
                }
            }
        }
        return facilityList
    }
    
    
    func getFoodPantries() -> [Facility] {
        var foodPantries = [Facility]()
        
        for facility in self.facilities {
            for feature in facility.featureList {
                if feature == "Food Pantry" {
                    foodPantries.append(facility)
                    break
                }
            }
        }
        return foodPantries
    }
    func getSoupKitchens() -> [Facility] {
        var soupKitchen = [Facility]()
        
        for facility in self.facilities {
            for feature in facility.featureList {
                if feature == "Soup Kitchen" {
                    soupKitchen.append(facility)
                    break
                }
            }
        }
        return soupKitchen
    }
}
