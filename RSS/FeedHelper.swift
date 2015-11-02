//
//  FeedHelper.swift
//  RSS
//
//  Created by Garrett Dycus on 3/17/15.
//  Copyright (c) 2015 Garrett Dycus. All rights reserved.
//

import UIKit

class FeedHelper: NSObject, NSXMLParserDelegate {
   
    var articles:[Article] = [Article]()
    
    //Parser variables
    var currentElement:String = ""
    var foundCharacters:String = ""
    var attributes:[NSObject:AnyObject]?
    var currentlyConstructingArticle:Article = Article()
    
    override init() {
        super.init()
        }
    
    func startParsing(feedUrlForParser:NSURL) {
        
        let feedParser:NSXMLParser? = NSXMLParser(contentsOfURL: feedUrlForParser)
        
        if let actualFeedParser = feedParser {
            
            //Download feed and parse out articles
            actualFeedParser.delegate = self
            actualFeedParser.parse()
        }

    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "entry" ||
            elementName == "title" ||
            elementName == "content" ||
            elementName == "link" {
                
                self.currentElement = elementName
                self.attributes = attributeDict
        }
        
        if elementName == "entry" {
            
            //Start new article
            self.currentlyConstructingArticle = Article()
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if self.currentElement == "entry" ||
            self.currentElement == "title" ||
            self.currentElement == "content" ||
            self.currentElement == "link" {
                
                self.foundCharacters += string
                
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "title" {
            
            //Parsiing of title element is complete, parse title into title property of article class
            let title:String = foundCharacters.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            self.currentlyConstructingArticle.articleTitle = title
            
        }
        else if elementName == "content" {
            
            //Parsing of content element is complete, parse content into content property of article class
            self.currentlyConstructingArticle.articleDesc = foundCharacters
            
            //Extract out article image from the content and save it to the articleImageUrl property of the article object
            
            //Search for http
            if let startRange = foundCharacters.rangeOfString("http", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                
                //If found, search for .jpg
                if let endRange = foundCharacters.rangeOfString(".jpg", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    
                    //If found, define image url from start to end range
                    let imgString:String = foundCharacters.substringWithRange(Range<String.Index>(start: startRange.startIndex, end: endRange.endIndex))
                    
                    //Assign to article property
                    self.currentlyConstructingArticle.articleImageUrl = imgString
                    
                }
                    //If .jpg is not found, search for .png
                else if let endRange = foundCharacters.rangeOfString(".png", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) {
                    
                    //If found, define image url from start to end range
                    let imgString:String = foundCharacters.substringWithRange(Range<String.Index>(start: startRange.startIndex, end: endRange.endIndex))
                    
                    //Assign to article property
                    self.currentlyConstructingArticle.articleImageUrl = imgString
                }
            }
        }
        else if elementName == "link" {
            
            //Parsing of link element is complete, grab the href key value pair out of the attributes dict
            self.currentlyConstructingArticle.articleLink = self.attributes!["href"] as! String
            
        }
        else if elementName == "entry" {
            
            //Parsing of an entry element is complete, append article object to our array
            self.articles.append(self.currentlyConstructingArticle)
            
        }
        
        //Reset foundCharacters
        self.foundCharacters = ""
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        //Use notification center to notify feed model
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("feedHelperFinished", object: self)
        
    }
    
}
