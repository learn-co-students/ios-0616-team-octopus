//
//  GeocodingAPI.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class GeocodingAPI {
    
    var elementArray: [Facility] = []
    var addresses: [String] = []
    var addressesObjects: [NSDictionary] = []
    //var latLotOfAddresses = [String: String]()
    
    let geocodingURL = "https://maps.googleapis.com/maps/api/geocode/json?"
    let geocodingAPI = "\(Secrets.googleGeocodingAPI)"
    
    
    func getGeoLatitudeLongtitudeByAddress() {
        self.parseData()
        self.getAddresses()
        self.getLocationWithCompletion { dictionary in
            let lat = dictionary["lat"]
            let lng = dictionary["lng"]
//            print(lat)
//            print(lng)
        
        
        }
        
    }
    
    // parsing XML to get the location info
    func parseData() {
        do {
            if let xmlURL = NSBundle.mainBundle().URLForResource("FacilityDetails", withExtension: "xml") {
                let xml = try String(contentsOfURL: xmlURL)
                let facilityParser = FacilityParser(withXML: xml)
                let facilities = facilityParser.parse()
                for facility in facilities {
                    elementArray.append(facility)
                }
            }
        } catch {
            print(error)
        }
        //print("=====elementArray \(self.elementArray[0])=====")
    }
    
    
    
    
    
    
    
    
    // making [String] of location as address based on location info
    func getAddresses() {
        for geo in self.elementArray {
            self.addresses.append(geo.fullAddress)
        }
        print("")
    }
    
    
    // request to get NSDictionary object by address
    func getLocationWithCompletion(completion: (AnyObject) -> ()) {
        
        // 1. create a session
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        // 2. create task for this session
        // 2.1 for this URL
        if let url = NSURL(string: "\(self.geocodingURL)address=\(self.addresses[1])&key=\(Secrets.googleGeocodingAPI)".stringByReplacingOccurrencesOfString(" ", withString: "%20")) {
            // 2.2 make a task that will
            let task = session.dataTaskWithURL(url) {
                (data, response, error) in
                
                // 2.3 get response
                if let data = data {
                    
                    do {
                        // response data from Google geocoding API server as JSON, convert to dictionary
                        let responseData = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
                        // LOOP THROUGHT DICTIONARY TO GET LOT AND LAT
                        var outputData = [String: AnyObject]()
                        for (key, value) in responseData {
                            if String(key) == "results" {
                                let newDictionary = value[0] as! [String: AnyObject]
                                for (key, value) in newDictionary {
                                    if String(key) == "geometry" {
                                        let locationDictionary = value
                                        for (key, value) in locationDictionary as! [String: AnyObject] {
                                            if String(key) == "location" {
                                                outputData = value as! [String: AnyObject]
                                            }
                                        }
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




