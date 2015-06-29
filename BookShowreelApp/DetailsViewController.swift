//
//  DetailsViewController.swift
//  BookShowreelApp
//
//  Created by Evgenios on 6/29/15.
//  Copyright (c) 2015 eug. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController {
    var books = [Book]()
    var selectedBook: Book?
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var bookText: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.selectedBook!.thumbURL)!)!)
        
        var bookString = "Title: " + (selectedBook!.title as String)
            
        bookString += "\nAuthors: " + (selectedBook!.authors as String)
        bookString += "\nPublished: " + (selectedBook!.publishdate as String) +
                         "\n\nDescription: " + selectedBook!.description
        
        bookText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        bookText.text = bookString
        
    }
}