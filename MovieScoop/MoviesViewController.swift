//
//  MoviesViewController.swift
//  MovieScoop
//
//  Created by Sabareesh Kappagantu on 3/29/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    var movies: [NSDictionary] = []
    var endpoint: String?
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.networkErrorView.isHidden = true
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        movieTableView.insertSubview(refreshControl, at: 0)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        networkRequest()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movies.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        //Get individual movie JSON
        
        if (movies.count != 0){
        
            let movie = movies[indexPath.section]
        
            //get Movie Title, imageURL, etc
            let movieTitle = movie.value(forKeyPath: "original_title") as? String
            let movieOverview = movie.value(forKeyPath: "overview") as? String
            if let movieBackgroundImagePath = movie.value(forKeyPath: "poster_path") as? String{
                let movieBackgroundImageURL = "http://image.tmdb.org/t/p/w185" + movieBackgroundImagePath
                //setting the imageView in the Cell
                if let realMovieBackgroundImageURL = URL(string: movieBackgroundImageURL) {
                    //cell.movieImageView.setImageWith(realMovieBackgroundImageURL)
                    let imageRequest = URLRequest(url: realMovieBackgroundImageURL)
                    cell.movieImageView.setImageWith(imageRequest,
                                                     placeholderImage: nil,
                                                     success: {(imageRequest, imageResponse, image) -> Void in
                                                        if imageResponse != nil {
                                                            print("Image not Cached, fading in image")
                                                            cell.movieImageView.alpha = 0.0
                                                            cell.movieImageView.image = image
                                                            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                                                                cell.movieImageView.alpha = 1.0
                                                            })
                                                        } else {
                                                            print("Image was cached, so just updated the image")
                                                            cell.movieImageView.image = image
                                                        }
                                                     },
                                                     failure: {(imageRequest, imageResponse, error) -> Void in
                                                        print("There was an error fetching the image!")
                                                     })
                } else {
                    //image did not load successfully
                    print("The image URL was messed up!")
                }
            }
            //setting the movieLabel in the Cell
            cell.movieCellLabel.text = movieTitle
            
            //setting the movieOverview in the Cell
            cell.movieCellOveriew.text = movieOverview
            
            
            return cell
        } else {
            //No Movies were Returned
            cell.textLabel?.text = "Something went Wrong!"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieTableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! MoviesDetailViewController
        let indexPath = movieTableView.indexPath(for: sender as! UITableViewCell)!
        
        //Sending the whole movie object
        let movie = movies[indexPath.section]
        detailView.movie = movie
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        networkRequest()
        self.refreshControl.endRefreshing()
    }
    
    func networkRequest () {
        
        let api_key = "98bc99e2be55777e277457b3de72dc05"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(api_key)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
       
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: {(data, response, error) in
            
            if let data = data {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let responseDictionary = try!JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.movieTableView.reloadData()
                }
            } else {
                print("There was a network error!")
                self.networkErrorView.isHidden = false
            }
        });
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
