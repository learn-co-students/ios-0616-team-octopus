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
        FacilityParser.getFacilitiesWithCompletion { (facilities) in
            for facility in facilities {
                self.facilities.append(facility)
            }
            completion()
        }
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
}
