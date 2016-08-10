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
}
