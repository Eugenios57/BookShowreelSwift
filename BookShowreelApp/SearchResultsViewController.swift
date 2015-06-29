//
//  SearchResultsViewController.swift
//  BookShowreelApp
//
//  Created by Evgenios on 6/29/15.
//  Copyright (c) 2015 eug. All rights reserved.
//
import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, APIControllerProtocol  {
    var books = [Book]()
    var api: APIController!
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String:UIImage]()
    @IBOutlet weak var appsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("Button for search clicked, searching for: " + searchBar.text)
        api.searchGoogleBooksFor(searchBar.text)
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println("Text is: " + searchBar.text)
        searchActive = false
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        let book = self.books[indexPath.row]
        
        cell.detailTextLabel?.text = book.authors
        
        cell.textLabel?.text = book.title
        
        cell.imageView?.image = UIImage(named: "Blank52")
        
        let thumbnailURLString = book.thumbURL
        let thumbnailURL = NSURL(string: thumbnailURLString)!
        
        
        if let img = imageCache[thumbnailURLString] {
            cell.imageView?.image = img
        }
        else {
            let request: NSURLRequest = NSURLRequest(URL: thumbnailURL)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data)
                    self.imageCache[thumbnailURLString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        return cell
    }
    
    func didReceiveAPIResults(results: NSArray) {
        
        println("Received results");
        
        dispatch_async(dispatch_get_main_queue(), {
            self.books = Book.bookFromJSON(results)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController: DetailsViewController = segue.destinationViewController as? DetailsViewController {
            var bookIndex = appsTableView!.indexPathForSelectedRow()!.row
            var selectedBook = self.books[bookIndex]
            detailsViewController.selectedBook = selectedBook
        }
        appsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
}

