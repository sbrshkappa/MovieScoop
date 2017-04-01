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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    
    var movies: [NSDictionary] = []
    var endpoint: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        let api_key = "98bc99e2be55777e277457b3de72dc05"
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(api_key)")! as URL, cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let httpError = error {
                print("\(httpError)")
            } else {
                if let respData = data {
                    if let responseDictionary = try!JSONSerialization.jsonObject(with: respData, options: []) as? NSDictionary {
                        print("response: \(responseDictionary)")
                        
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.movieTableView.reloadData()
                    }
                }
            }
        })
        
        dataTask.resume()
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
                    cell.movieImageView.setImageWith(realMovieBackgroundImageURL)
                } else {
                    //image did not load successfully
                    print("Not displaying image")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
