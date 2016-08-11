//
//  GeocodingAPI.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class GeocodingAPI {
    
    let store = FacilityDataStore.sharedInstance
    
    var addresses: [String] = []
    var addressesObjects: [NSDictionary] = []
    
    let geocodingURL = "https://maps.googleapis.com/maps/api/geocode/json?"
    let geocodingAPI = "\(Secrets.googleGeocodingAPI)"
    
    
    func getGeoLatitudeLongtitudeByAddress() {
        self.getAddresses()
        for i in 0...1 {
            self.getLocationWithCompletion(self.addresses[i]) {
                dictionary in
                
                for facility in self.store.facilities {
                    
                    if facility.fullAddress == self.addresses[i] {
                        
                        let latDict = dictionary["lat"]
                        if let latitude = latDict {
                            facility.latitude = Double(latitude as! NSNumber)
                        }
                        let lngDict = dictionary["lng"]
                        if let longitude = lngDict {
                            facility.longitude = Double(longitude as! NSNumber)
                        }
                        
                        
//                        facility.latitude = String(dictionary["lat"])
//                        facility.longitude = String(dictionary["lng"])
                        //print(facility.latitude)
                        //print("JJJJJJJJ\(self.store.facilities[i].description)jjj")
                    }
                }
            }
        }
    }
    
    
    // making [String] of addresses based on location info
    func getAddresses() {
        for geo in self.store.facilities {
            self.addresses.append(geo.fullAddress)
        }
    }
    
    
    // request to get NSDictionary object by address
    func getLocationWithCompletion(address: String, completion: ([String: AnyObject]) -> ()) {
        
        // 1. create a session
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        // 2. create task for this session
        // 2.1 for this URL
        if let url = NSURL(string: "\(self.geocodingURL)address=\(address)&key=\(Secrets.googleGeocodingAPI)".stringByReplacingOccurrencesOfString(" ", withString: "%20")) {
            
            // 2.2 make a task that will
            let task = session.dataTaskWithURL(url) {
                (data, response, error) in
                
                // 2.3 get response
                if let data = data {
                    
                    do {
                        // response data from Google geocoding API server as JSON, convert to dictionary
                        let responseData = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
                        
                        // LOOP THROUGHT DICTIONARY TO GET LOT AND LAT
                        var outputData = [String: AnyObject]()
                        
                        if let responseData = responseData {
                            let oneDictionary = responseData["results"]![0] as? [String: AnyObject]
                            if let oneDictionary = oneDictionary {
                                let locationDictionary = oneDictionary["geometry"] as? [String: AnyObject]
                                if let locationDictionary = locationDictionary {
                                    let output = locationDictionary["location"] as? [String: AnyObject]
                                    if let output = output {
                                        outputData = output
                                    }
                                }
                            }
                        }
                        
                        completion(outputData)
                        
                        
                        
//                        if let responseData = responseData {
//                            for (key, value) in responseData {
//                                if String(key) == "results" {
//                                    let newDictionary = value[0] as? [String: AnyObject]
//                                    if let newDictionary = newDictionary {
//                                        for (key, value) in newDictionary {
//                                            if String(key) == "geometry" {
//                                                let locationDictionary = value as? [String: AnyObject]
//                                                if let locationDictionary = locationDictionary {
//                                                    for (key, value) in locationDictionary {
//                                                        if String(key) == "location" {
//                                                            let output = value as? [String: AnyObject]
//                                                            if let output = output {
//                                                                outputData = output
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
                      
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            // 3. begin request to server (with created session and task)
            task.resume()
        }
    }
}




