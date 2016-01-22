//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Samira Baird on 1/13/16.
//  Copyright © 2016 Samira Baird. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInstagramByHashtag("dogs")
        
    }
   
    func searchInstagramByHashtag(searchString:String) {
        let manager = AFHTTPSessionManager()
        manager.GET("https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=YOUR_CLIENT_ID",
            parameters: nil,
            progress: nil,
            success: { (operation: NSURLSessionDataTask,responseObject: AnyObject?) in
                if let responseObject = responseObject {
                    if let dataArray = responseObject["data"] as? [AnyObject] {
                        var urlArray:[String] = []
                        for dataObject in dataArray {
                            if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                                urlArray.append(imageURLString)
                            }
                        }
                        
                        self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))
                        
                        for var i = 0; i < urlArray.count; i++ {
                            let imageView = UIImageView(frame: CGRectMake(0, 320*CGFloat(i), 320, 320))
                            if let url = NSURL(string: urlArray[i]) {
                                imageView.setImageWithURL( url)
                                self.scrollView.addSubview(imageView)
                            }
                        }
                        
                    }
                }
            },
            failure: { (operation: NSURLSessionDataTask?,error: NSError) in
                print("Error: " + error.localizedDescription)
        })
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            searchInstagramByHashtag(searchText)
        }
        
    }
}
