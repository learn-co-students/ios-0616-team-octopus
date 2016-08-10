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
    var facilities: [FacilityDetails] = []
    var xmlText = String()
    var currentFacility: FacilityDetails?
    
    init(withXML xml: String) {
        
        if let data = xml.dataUsingEncoding(NSUTF8StringEncoding) {
            xmlParser = NSXMLParser(data: data)
        }
    }
    
    func parse() -> [FacilityDetails] {
        xmlParser?.delegate = self
        xmlParser?.parse()
        
        return facilities
    }
}

extension FacilityParser {
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        xmlText = ""
        if elementName == "facility" {
            currentFacility = FacilityDetails()
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
            currentFacility?.zipCode = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        if elementName == "phone-number" {
            currentFacility?.phoneNumber = xmlText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
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

