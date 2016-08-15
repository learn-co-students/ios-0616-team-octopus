//
//  FacilityXMLParser.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

// 

import Foundation


class FacilityParser: NSObject, NSXMLParserDelegate {
    
    var xmlParser: NSXMLParser?
    var facilities: [Facility] = []
    var xmlText = String()
    var currentFacility: Facility?
    
    init(withXML xml: String) {
        
        if let data = xml.dataUsingEncoding(NSUTF8StringEncoding) {
            xmlParser = NSXMLParser(data: data)
        }
    }
    
    func parse() -> [Facility] {
        xmlParser?.delegate = self
        xmlParser?.parse()
        
        return facilities
    }
    
    class func getFacilitiesWithCompletion(completion: ([Facility]) -> ()) {
        
        do {
            if let xmlURL = NSBundle.mainBundle().URLForResource("FacilityDetails", withExtension: "xml") {
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
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        xmlText = ""
        if elementName == "facility" {
            currentFacility = Facility()
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "name" {
            currentFacility?.name = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "brief-description" {
            currentFacility?.briefDescription = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "street-address" {
            currentFacility?.streetAddress = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "city" {
            currentFacility?.city = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "state" {
            currentFacility?.state = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "zip-code" {
            currentFacility?.zipcode = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "phone-number" {
            currentFacility?.phoneNumber = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "hours-of-operation" {
            currentFacility?.hoursOfOperation = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "intake" {
            currentFacility?.intake = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "fee" {
            currentFacility?.fee = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "eligibility" {
            currentFacility?.eligibility = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "required-documents" {
            currentFacility?.requiredDocuments = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        xmlText += string
        
    }
    
    
}

