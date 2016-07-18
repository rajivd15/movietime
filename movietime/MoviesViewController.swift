//
//  ViewController.swift
//  movietime
//
//  Created by Rajiv Deshmukh on 7/15/16.
//  Copyright © 2016 Rajiv Deshmukh. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var movies : [NSDictionary]! = [NSDictionary]()
    let poster_path : String = "https://image.tmdb.org/t/p/w342/"
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I am here")
        
        //UI Refresh Control 
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        // Do any additional setup after loading the view, typically from a nib.
        
        let clientId = "3cca78394a9e5331dcca77881cc68d5d"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                      completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary {
                                                                                
                                                                                if let moviesFetch = responseDictionary["results"] as? [NSDictionary] {
                                                                                    self.movies = moviesFetch
                                                                                    NSLog("response: \(self.movies)")
                                                                                    self.tableView.reloadData()
                                                                                }
                                                                            }
                                                                        }
        });
        task.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieTableViewCell", forIndexPath: indexPath) as! MovieTableViewCell

        if let movieFetched = movies[indexPath.row] as? NSDictionary {
            cell.movieTitleLabel.text = movieFetched["title"] as? String
            cell.movieDescriptionLabel.text = movieFetched["overview"] as? String
            
            if let posterPathFetched = movieFetched["poster_path"] as? String {
                let posterURL = NSURL(string: poster_path + posterPathFetched)
                cell.movieImageView.setImageWithURL(posterURL!)
            }
            
        }
        return cell
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshContro
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let clientId = "3cca78394a9e5331dcca77881cc68d5d"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                      completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary {
                                                                                
                                                                                if let moviesFetch = responseDictionary["results"] as? [NSDictionary] {
                                                                                    self.movies = moviesFetch
                                                                                    NSLog("response: \(self.movies)")
                                                                                    self.tableView.reloadData()
                                                                                    
                                                                                    // Tell the refreshControl to stop spinning
                                                                                    refreshControl.endRefreshing()
                                                                                }
                                                                            }
                                                                        }
        });
        task.resume()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Get rid of the gray selection effect by deselecting the cell with animation
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        print("prepare for segue")
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies[(indexPath?.row)!]
        
        let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
        movieDetailViewController.movie = movie
     }

}

