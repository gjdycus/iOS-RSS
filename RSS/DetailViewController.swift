//
//  DetailViewController.swift
//  RSS
//
//  Created by Garrett Dycus on 3/16/15.
//  Copyright (c) 2015 Garrett Dycus. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var articleToDisplay:Article?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Add icon to nav item title bar
        let titleIcon:UIImageView = UIImageView(frame: CGRectMake(0, 0, 41, 33))
        titleIcon.image = UIImage(named: "vergeicon")
        self.navigationItem.titleView = titleIcon
       
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Check if there's an article to display
        if let actualArticle = self.articleToDisplay {
            
            //Create NSURL for the article URL
            let url:NSURL? = NSURL(string: actualArticle.articleLink)
            
            //Check if an NSURL object was created
            if let actualUrl = url {
                
                //Create NSURLRequest for the NSURL
                let urlRequest:NSURLRequest = NSURLRequest(URL: actualUrl)
                
                //Pass the request into the web view to load the page
                self.webView.loadRequest(urlRequest)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
