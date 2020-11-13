//
//  ParseRSS.swift
//  News
//
//  Created by Rotach Roman on 13.11.2020.
//

import Foundation

struct RSS {
    var titleNews: String
    var textNews: String
    var dateNews: String
}


final class ParserRSS: NSObject, XMLParserDelegate
{
    private var myData: Data
    private var currentElementName = ""
    private var inItem = false
    private var inChannel = false
    private var item: RSS
    var ready = false
    
    var channel: RSS
    var items: [RSS]
    
    override init() {
        myData = "".data(using: .ascii)!
        channel = RSS(titleNews: "", textNews: "", dateNews: "")
        items = []
        item = channel
    }
    
    //Sets the local data set for parsing
    
    func setData(data: Data!) {
        
        if data == nil {
            return
        }
        myData = data
    }
    
    // Runs the parsing process, returns at end
    func parse(){
        let parser = XMLParser(data: myData)
        parser.delegate = self
        parser.parse()
    }
    
    // Terminate session
    func parserDidEndDocument(_ parser: XMLParser) {
        ready = true
    }
    
    // Start a new session
    func parserDidStartDocument(_ parser: XMLParser) {
        ready = false
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            inItem = false
            items.append(item)
            return
        }
        if elementName == "channel"
        {
            inChannel = false
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName
        if elementName == "item"
        {
            inItem = true
            item = RSS(titleNews: "", textNews: "", dateNews: "")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElementName.lowercased()
        {
        case "title":
            item.titleNews += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "description":
            item.textNews += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        case "pubdate":
            item.dateNews += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        default:
            break
        }
    }
}
