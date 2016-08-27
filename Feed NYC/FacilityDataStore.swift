//
//  FacilityDataStore.swift
//  Feed NYC
//
//  Created by Henry Dinhofer on 8/10/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import MapKit


class FacilityDataStore {
    static let sharedInstance = FacilityDataStore()
    private init() {  }
    
    var facilities : [Facility] = []
    var facilitiesDictionary : [String : Facility] = [:]
    var currentLocationCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var closestFacility : Facility?
    
    
    // Reads in Facilities.txt,  and creates singleton
    // When you need to update with new data use the method: printXMLFile()
    func readInTextFile() {
        guard self.facilities.count == 0 else { return }
        guard self.facilitiesDictionary.count == 0 else { return }
       
        
        if let filepath = NSBundle.mainBundle().pathForResource("Facilities", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath, usedEncoding: nil) as String
   
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
    // MARK: -Use this method when we have a new XML file
    //    Make sure geo.getGeoLatitudeLongtitudeByAddress() for loop runs from 0..<self.store.facilities.count
    //    It will take at least a minute to run
    func printXMLFile() {
        
        //Read XML files
        self.refreshFacilitiesDataStoreWithCompletion { [weak weakSelf = self] in
            
            // Ask google to convert locations to latitude and longitude
            let geo = GeocodingAPI()
            geo.getGeoLatitudeLongtitudeByAddress()  // <-- Make sure that the for loop inside this method from 0..<self.store.facilities.count
                                                     //
            
            // Check facilities for duplicate Geolocations
            self.checkAndRemoveDuplicateFacilities()
            
            // Call method to  Print the facility dictionary  -- what you copy, then paste into the Facilities.txt file
            weakSelf?.setUpFacilitiesForOutputToJSON()
        }
    }
    
    
    
    // Parses XML file and populates Singleton with Facility objects
    // Facility array still contains duplicates
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
    // Checks self.facilities for duplicate Street Addresses
    //  Problem was 619 lexington avenue != 619  Lexington Avenue, so a few duplicates get through
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
        // Sleep waits 60 seconds for the googleMaps GeocodingAPI to finish, yes its not a true multithreading dependency but eh it works
        print ("Please wait 60 seconds for googleMaps GeocodingAPI to finish...")
        sleep(60)
        
        var i = 0
        var masterDictionaryOfFacilities = [String : AnyObject]()
        
        // Iterates over facilities to create facilitiesDictionary
        while i < self.facilities.count {
            let currentFacility = self.facilities[i]
            let dictionaryFacility = currentFacility.toDictionary()
            
            // This string will be the key into self.facilitiesDictionary
            // I.e. let facilityWeWant = facilitiesDictionary[coordinatesString]    
            let coordinatesString = "\(currentFacility.latitude) \(currentFacility.longitude)"

            masterDictionaryOfFacilities[coordinatesString] = dictionaryFacility
            i += 1
        }
        
        // print (masterDictionaryOfFacilities)
        
        
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
            for (coordinate, facility) in dict {
                
                //                print(facility)
                let newFacility = Facility.makeFacility(facility)
                //MARK: -Cenker we could add user distance to facility here
                //  newFacility.distanceFromCurrentLocation =
                
                //                print(newFacility)
                //                print(coordinate)
                self.facilities.append(newFacility)
                self.facilitiesDictionary[coordinate] = newFacility
            }
        }
//                print(self.facilities)
//                print(self.facilitiesDictionary)
//                print(self.facilities.count)
//                print(self.facilitiesDictionary.count)
    }
    
    // Checks Facility for duplicates that have the same coordinates
    func checkAndRemoveDuplicateFacilities()
    {
        var i = 0
        var j = 0
        var duplicateCount = 0
        var duplicateFacilities = [Facility]()
        
        // Iterate over array comparing all Facilities's Latitude+Longitudes
        while i < self.facilities.count {
            j = i + 1
            let firstCoordinates = "\(facilities[i].latitude) \(facilities[i].longitude)"
            
            while j < self.facilities.count {
                let secondCoordinates = "\(facilities[j].latitude) \(facilities[j].longitude)"
                
                if firstCoordinates == secondCoordinates {
                    duplicateCount += 1
                    duplicateFacilities.append(facilities[i])
                    duplicateFacilities.append(facilities[j])
                    
                    // Check if the duplicate entry is a food pantry or soup kitchen and set hoursOfOperation to special character
                    if facilities[j].featureList.contains("Food Pantry") && facilities[j].featureList.contains("Soup Kitchen") {
                      // Do nothing
                    } else if facilities[j].featureList.contains("Food Pantry") {
                        self.facilities[i].hoursOfOperation.appendContentsOf(" & Food Pantry \(facilities[j].hoursOfOperation)")
                    } else if facilities[j].featureList.contains("Soup Kitchen") {
                        self.facilities[i].hoursOfOperation.appendContentsOf(" & Soup Kitchen \(facilities[j].hoursOfOperation)")
                    }
                    self.facilities.removeAtIndex(j)
                    print("Updated facility is now \(self.facilities[i])")
                }
                j += 1
            }
            i += 1
        }
//        print ("Duplicate Count is \(duplicateCount)\n \(duplicateFacilities)")
        
    }
    
    //
    // featureToCompare is either "Soup Kitchen" or "Food Pantry"
    //    Method example call: self.store.getFacilitiesThatHave(feature: Facility.foodType.FoodPantry)
    func getFacilitiesThatHave(feature featureToCompare: Facility.foodType) -> [Facility]{
        var facilityList = [Facility]()
        
        for facility in self.facilities {
            for feature in facility.featureList {
                if feature == featureToCompare.rawValue {  // Uses Facility enum with rawValue equal to either "Soup Kitchen" or "Food Pantry"
                    facilityList.append(facility)
                    break
                }
            }
        }
        
        //
        return facilityList.sort{$0.name < $1.name}
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
