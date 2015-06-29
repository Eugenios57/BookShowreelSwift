//
//  Book.swift
//  BookShowreelApp
//
//  Created by Evgenios on 6/29/15.
//  Copyright (c) 2015 eug. All rights reserved.
//

import Foundation

struct Book {
    let title: String
    let authors: String
    let publishdate: String
    let description: String
    let thumbURL: String
    
    init(title: String, authors: String, publishdate: String,
        description: String, thumbURL: String) {
        self.title = title
        self.authors = authors
        self.publishdate = publishdate
        self.description = description
        self.thumbURL = thumbURL
    }
    
    static func bookFromJSON(items: NSArray) -> [Book] {
        // create an array of books
        var books = [Book]()
        
        // store the results in our table data
        if items.count > 0 {
            for item in items {
                
                let itemVolumeInfo = item["volumeInfo"] as! NSDictionary
                let title = itemVolumeInfo["title"] as! String
                let published = itemVolumeInfo["publishedDate"] as! String
                let description = ""
                //let description = itemVolumeInfo["description"] as! String
                
                
                println("Book named: " + title)
                println("\tPublished in: " + published)
                //println("\tDescription: " + description)
                
                let thumbNail = itemVolumeInfo["imageLinks"] as! NSDictionary
                let thumbNailURL = thumbNail["smallThumbnail"] as! String
                
                let authorArray = itemVolumeInfo["authors"] as! NSArray
                
                var authorString = ""
                if authorArray.count > 0 {
                    for var i = 0; i < authorArray.count; i++ {
                        if(i > 0) {authorString = authorString + ", "}
                        authorString = authorString + (authorArray[i] as! String)
                    }
                }
                
                println("Authors: " + authorString)
                println("\tThumbnail URL: " + thumbNailURL)
                println("\n")
                
                var newBook = Book(title: title, authors: authorString, publishdate: published,
                    description: description, thumbURL: thumbNailURL)
                
                books.append(newBook)
                
            }
        }
        return books
    }
}
