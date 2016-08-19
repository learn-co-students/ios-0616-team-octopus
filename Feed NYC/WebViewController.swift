//
//  WebViewController.swift
//  Feed NYC
//
//  Created by Flatiron School on 8/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webViewer: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewer.delegate = self
        loadWebPage()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebPage() {
        let url = NSURL(string: "http://www1.nyc.gov/apps/311utils/facilityFinderResults.htm?requestType=&serviceName=Find%20a%20Food%20Pantry%20or%20Soup%20Kitchen&viewType=SHOWALL&type=Food%20Provider&serviceId=1083#")
        let request = NSURLRequest(URL: url!)
        webViewer.scalesPageToFit = true
        webViewer.contentMode = .ScaleAspectFit
        webViewer.loadRequest(request)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
}
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    
        print("There was a problem loading the web page!")
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
