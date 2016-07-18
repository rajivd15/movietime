//
//  MovieDetailViewController.swift
//  movietime
//
//  Created by Rajiv Deshmukh on 7/17/16.
//  Copyright © 2016 Rajiv Deshmukh. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var detailOverviewLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    let poster_path : String = "https://image.tmdb.org/t/p/w342/"

    var movie : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(movie)
        detailScrollView.contentSize = CGSize(width: detailScrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as! String
        detailTitleLabel.text = title

        let overview = movie["overview"] as! String
        detailOverviewLabel.text = overview
        detailOverviewLabel.sizeToFit()
        

        if let posterPathFetched = movie["poster_path"] as? String {
            let posterURL = NSURL(string: poster_path + posterPathFetched)
            moviePosterImageView.setImageWithURL(posterURL!)
        }
        // Do any additional setup after loading the view.
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
