//
//  FacilityDataStore.swift
//  Feed NYC
//
//  Created by Henry Dinhofer on 8/10/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

// Fix 3 XML
// Make JSON
// Convert from JSON
// Prepare GoogleLocations api for hits


class FacilityDataStore {
    static let sharedInstance = FacilityDataStore()
    private init() {}
    
    var facilities : [Facility] = []
    var facilitiesDictionary : [String : Facility] = [:]
    
    // Reads in Facilities.txt,  and creates singleton
    // When you need to update with new data use the method: printFacilitiesTextFilenWhenWeUpdateWithNewXMLFile()
    func readInTextFile() {
        if let filepath = NSBundle.mainBundle().pathForResource("Facilities", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath, usedEncoding: nil) as String
                //                print(contents)
                
                
                
                // Parses out Facilities.txt and populates facilities : [Facility] , facilitiesDictionary : [String : Facility ]
                self.getFacilitiesFromJSONFile(contents)
            } catch {
                print ("Unable to read in .txt file \(error)")
            }
        } else {
            print("Couldn't find Facilities.txt file inside project")
        }
        
    }
    
    // When 311 updates their XML file, and we replace the FacilityDetails.xml file
    // This method will parse the new XML,
    // update the Facility objects with correct GPS latitude and longitudes,
    // create a facilitiesDictionary, then
    // convert the new facilitiesDictionary to a string (a json string) in the debug area
    //
    // Developer then copy paste and add it to Facilities.txt
    // Displays the new Facilities.txt file in the debug area
    private func printFacilitiesTextFilenWhenWeUpdateWithNewXMLFile() {
        self.refreshFacilitiesDataStoreWithCompletion { [weak weakSelf = self] in
            let geo = GeocodingAPI()
            geo.getGeoLatitudeLongtitudeByAddress()  // Make sure that the for loop inside is from 0..<self.store.facilities.count
            weakSelf?.setUpFacilitiesForOutputToJSON()
        }
    }
    
    func refreshFacilitiesDataStoreWithCompletion(completion: () -> ()) {
        facilities.removeAll()
        FacilityParser.getFacilitiesWithCompletion { (parsedFacilities) in
            self.cleanRedundantFacilities(parsedFacilities, completion: { (cleanedFacilities) in
                self.facilities = cleanedFacilities
                //                print(self.facilities[20])
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
    
    
    
    // Converts self.facilities to facilityDictionary, makes facilityDictionary into a jsonable string
    func setUpFacilitiesForOutputToJSON() {
        // Sleep waits for the googleMaps GeocodingAPI to finish
        sleep(60)
        
        var i = 0
        var masterDictionaryOfFacilities = [String : AnyObject]()
        
        // Iterates over facilities to create facilitiesDictionary
        while i < self.facilities.count {
            let currentFacility = self.facilities[i]
            let dictionaryFacility = currentFacility.toDictionary()
            
            //            print(dictionaryFacility)
            
            
            masterDictionaryOfFacilities[currentFacility.streetAddress] = dictionaryFacility
            i += 1
        }
        
//                print (masterDictionaryOfFacilities)
        
        
        //  creating JSON out of the above dictionary
        var jsonData: NSData!
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(masterDictionaryOfFacilities, options: NSJSONWritingOptions())
            let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding)!
            print(jsonString) // Where the magic happens
            //                    print(jsonData)
        } catch let error as NSError {
            print("Array to JSON conversion failed: \(error.localizedDescription)")
        }
        
    }
    
    
    // Would help to convert to a completion block
    // This method "pulls apart" the Facilities.txt string, parsing it out into the objects that comprise self.facilities and self.facilitiesDictionary
    func getFacilitiesFromJSONFile(jsonString: String) {
        
        if let
            data = jsonString.dataUsingEncoding(NSUTF8StringEncoding),
            object = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
            dict = object as? [String : NSDictionary] {
            for (streetAddress, facility) in dict {
                
                //                print(facility)
                let newFacility = Facility.makeFacility(facility)
                //                print(newFacility)
                //                print(streetAddress)
                self.facilities.append(newFacility)
                self.facilitiesDictionary[streetAddress] = newFacility
            }
        }
//        print(self.facilities)
//        print(self.facilities.count)
        print(self.facilitiesDictionary.count)
    }
    
    func checkDuplicates()
    {
        var i = 0
        var j = 0
        var duplicateCount = 0
        var duplicateFacilities = [Facility]()
        while i < self.facilities.count {
            j = i + 1
            while j < self.facilities.count {
                if facilities[i].streetAddress == facilities[j].streetAddress {
                    duplicateCount += 1
                    duplicateFacilities.append(facilities[i])
                    duplicateFacilities.append(facilities[j])
                }
                j += 1
            }
            i += 1
        }
                print ("Duplicate Count is \(duplicateCount)\n \(duplicateFacilities)")
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
    
    
    func getFoodPantryFacilities() -> [Facility] {
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
    func getSoupKitchenFacilities() -> [Facility] {
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
