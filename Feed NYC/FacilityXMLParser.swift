//
//  FacilityXMLParser.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

// 

import Foundation


class FacilityParser: NSObject, XMLParserDelegate {
    
    var xmlParser: XMLParser?
    var facilities: [Facility] = []
    var xmlText = String()
    var currentFacility: Facility?
    
    init(withXML xml: String) {
        
        if let data = xml.data(using: String.Encoding.utf8) {
            xmlParser = XMLParser(data: data)
        }
    }
    
    func parse() -> [Facility] {
        xmlParser?.delegate = self
        xmlParser?.parse()
        
        return facilities
    }
    
    class func getFacilitiesWithCompletion(_ completion: ([Facility]) -> ()) {
        
        do {
            if let xmlURL = Bundle.main.url(forResource: "FacilityDetails", withExtension: "xml") {
                let xml = try String(contentsOfURL: xmlURL)
                let facilityParser = FacilityParser(withXML: xml)
                let facilities = facilityParser.parse()
                completion(facilities)
            }
            
        } catch {
            print(error)
        }
        

    }

}

extension FacilityParser {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        xmlText = ""
        if elementName == "facility" {
            currentFacility = Facility()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "name" {
            currentFacility?.name = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "brief-description" {
            currentFacility?.briefDescription = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "street-address" {
            currentFacility?.streetAddress = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "city" {
            currentFacility?.city = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "state" {
            currentFacility?.state = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "zip-code" {
            currentFacility?.zipcode = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "phone-number" {
            currentFacility?.phoneNumber = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "hours-of-operation" {
            currentFacility?.hoursOfOperation = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "intake" {
            currentFacility?.intake = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "fee" {
            currentFacility?.fee = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "eligibility" {
            currentFacility?.eligibility = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "required-documents" {
            currentFacility?.requiredDocuments = xmlText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        if elementName == "feature" {
            currentFacility?.featureList.append(xmlText)
        }
        
        
        if elementName == "facility" {
            if let facility = currentFacility {
                facilities.append(facility)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
        
    }
    
    
}

