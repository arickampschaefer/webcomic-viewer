
//
//  ViewController.swift
//  webcomic-viewer
//
//  Created by Aric Kampschaefer on 9/27/15.
//  Copyright (c) 2015 Aric Kampschaefer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicImage: UIImageView!
    var nextComic: String?
    var previousComic: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let startingComic = "http://euge.ca/"
        nextComic = startingComic
        parseHTMLFromURL(startingComic)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func getPrevious(sender: AnyObject) {
        parseHTMLFromURL(previousComic!)
    }

    @IBAction func getNext(sender: AnyObject) {
        parseHTMLFromURL(nextComic!)
    }
    
    // MARK: - HTML Parsing
    
    func parseHTMLFromURL(currentComic: String) {
        
        
        var url = NSURL(string: currentComic)
        var session = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: currentComic)!,
            completionHandler : {(data, response, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    let HTMLData = data
                    let parser = TFHpple(HTMLData: HTMLData)
                    // query for image
                    if let elements = parser.searchWithXPathQuery("//div[@class='entry']//img/@src|//div[@class='post']/center/h2/a|//div[@class='alignright']|//div[@class='alignleft']") as? [TFHppleElement]{
                        if elements[0].firstChildWithTagName("a") != nil {
                            self.previousComic = elements[0].firstChildWithTagName("a").objectForKey("href")
                        }
                        if elements[1].firstChildWithTagName("a") != nil {
                            self.nextComic = elements[1].firstChildWithTagName("a").objectForKey("href")
                        }
                        self.comicTitle.text = elements[2].content
                        self.comicImage.image =  UIImage(data: NSData(contentsOfURL: NSURL(string: elements[3].content)!)!)
                    }
                })
        })
        session.resume()
    }

}

