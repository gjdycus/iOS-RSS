//
//  FeedModel.swift
//  RSS
//
//  Created by Garrett Dycus on 3/17/15.
//  Copyright (c) 2015 Garrett Dycus. All rights reserved.
//

import UIKit

protocol FeedModelDelegate {
    
    //Any FeedModelDelegate must implement this method
    //FeedModel will call this method when article array is ready
    func articlesReady()
    
}

class FeedModel: NSObject {
   
    
    
    let feedUrlString:String = "http://www.theverge.com/rss/frontpage"
    var articles:[Article] = [Article]()
    var delegate:FeedModelDelegate?
    var feedHelper:FeedHelper = FeedHelper()
    
    func getArticles() {
        
        //Create URL
        let feedUrlForParser:NSURL? = NSURL(string: feedUrlString)
        
        //Listen to notification center
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("parserFinished"), name: "feedHelperFinished", object: self.feedHelper)
        
        //Kick off feed helper to parse NSURL
        self.feedHelper.startParsing(feedUrlForParser!)
        
               
    } //End getArticles
    
    func parserFinished() {
        
        //Assign parser's list of articles to self.articles
        self.articles = self.feedHelper.articles
        
        //Notify the view controller that the array of articles is ready
        
        //Check if there's an object assigned as the delegate
        //If so, call the articlesReady method on the delegate
        if let actualDelegate = self.delegate {
            
            //There is an object assigned to the delegate property
            actualDelegate.articlesReady()
        }
        
    }
    
}
