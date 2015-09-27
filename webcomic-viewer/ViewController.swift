
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

        let HTMLData = NSData(contentsOfURL: NSURL(string: currentComic)!)!
        
        let parser = TFHpple(HTMLData: HTMLData)
        // query for image
        if let elements = parser.searchWithXPathQuery("//div[@class='entry']//img/@src") as? [TFHppleElement]{
            for element in elements{
                comicImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: element.content)!)!)
            }
        }
        // query for title
        if let elements = parser.searchWithXPathQuery("//div[@class='post']/center/h2/a") as? [TFHppleElement]{
            for element in elements{
                comicTitle.text = element.content
            }
        }
        // query for next comic
        if let elements = parser.searchWithXPathQuery("//div[@class='alignright']/a/@href") as? [TFHppleElement]{
            for element in elements{
                nextComic = element.content
                println(element.content)
            }
        }
        // query for previous comic
        if let elements = parser.searchWithXPathQuery("//div[@class='alignleft']/a/@href") as? [TFHppleElement]{
            for element in elements{
                previousComic = element.content
                println(element.content)
            }
        }

    }

}

