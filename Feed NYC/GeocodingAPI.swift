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
    
    
    // MARK: -Gets locations from GoogleMaps API
    // Make sure the for loop is "for i in 0..<self.store.facilities.count"
    func getGeoLatitudeLongtitudeByAddress() {
        
        // get full addresses of locations
        self.getAddresses()
        
        // based on full addresses set Lat and Lng for each location accordingly
        for i in 0..<2 {   // Update for loop here

            self.getLocationWithCompletion(self.addresses[i]) {
                dictionary in
                
                if i % 20 == 0 {
                    sleep(1)
                }
                
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
                            
                            //NOTE: Had to change it to test on iPhone. It was originally  let oneDictionary = responseData["results"]![0] as? [String: AnyObject]
                            let oneDictionary = (responseData["results"] as! NSArray) [0] as? [String: AnyObject]
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




