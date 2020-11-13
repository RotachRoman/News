//
//  RSSParser.swift
//  News
//
//  Created by Rotach Roman on 12.11.2020.
//

import UIKit


final class RSSParser: NSObject, XMLParserDelegate {
    var xmlParser: XMLParser!
    var currentElement = ""
    var foundCharacters = ""
    var currentData = [String:String]()
    var parsedData = [[String:String]]()
    var isHeader = true
    
    func startParsingWithContentsOfURL(rssURl: URL, with completion: (Bool)->() ){
        let parser = XMLParser(contentsOf: rssURl)
        parser?.delegate = self
        if let flag = parser?.parse() {
            parsedData.append(currentData)
            completion(flag)
        }
        
        print(parser ?? 0)
        print(currentData)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String,  namespaceURI: String?, qualifiedName: String?, attributes attributeDict: [String : String] = [:]){
        
        currentElement = elementName
        
        if currentElement == "item" || currentElement == "entry" {
            if isHeader == false {
                parsedData.append(currentData)
            }
            isHeader = false
        }
        if isHeader == false {
            if currentElement == "media:thumbail" || currentElement == "media:content"{
                foundCharacters += attributeDict["url"]!
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if isHeader == false {
            if currentElement == "title", currentElement == "description", currentElement == "pubDate" {
                foundCharacters += string
                foundCharacters = foundCharacters.deleteHTMLTags(tags: ["a", "p", "div"])
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty{
            
            foundCharacters = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            currentData[currentElement] = foundCharacters
            foundCharacters = ""
        }
    }
}


extension String {
    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
}
