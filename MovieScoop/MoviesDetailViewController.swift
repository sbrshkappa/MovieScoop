//
//  MoviesDetailViewController.swift
//  MovieScoop
//
//  Created by Sabareesh Kappagantu on 3/31/17.
//  Copyright © 2017 Sabareesh Kappagantu. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesDetailViewController: UIViewController {
    
    var movie: NSDictionary?
    
    
    @IBOutlet weak var movieDetailImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieDetailScrollView: UIScrollView!
    @IBOutlet weak var movieInfoView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(movie!)
        
        movieDetailScrollView.contentSize = CGSize(width: movieDetailScrollView.frame.size.width, height: movieInfoView.frame.origin.y + movieInfoView.frame.size.height)
        
        let baseImageURL = "http://image.tmdb.org/t/p/w342"
        let movieTitleString = movie!["original_title"] as! String
        let movieOverviewString = movie!["overview"] as! String
        
        if let imageURL = movie!["poster_path"] as? String {
            let realImageURL = URL(string: baseImageURL+imageURL)
            let imageRequest = URLRequest(url: realImageURL!)
            movieDetailImageView.setImageWith(imageRequest,
                                             placeholderImage: nil,
                                             success: {(imageRequest, imageResponse, image) -> Void in
                                                if imageResponse != nil {
                                                    print("Image not Cached, fading in image")
                                                    self.movieDetailImageView.alpha = 0.0
                                                    self.movieDetailImageView.image = image
                                                    UIView.animate(withDuration: 0.3, animations: {() -> Void in
                                                        self.movieDetailImageView.alpha = 1.0
                                                    },
                                                    completion: {(success) -> Void in
                                                        let highResImageURL = URL(string: "http://image.tmdb.org/t/p/w500" + imageURL)
                                                        let highResImageRequest = URLRequest(url: highResImageURL!)
                                                        self.movieDetailImageView.setImageWith(highResImageRequest,
                                                            placeholderImage: image,
                                                            success: {(highResImageRequest, highResImageResponse, highResImage) -> Void in
                                                                self.movieDetailImageView.image = highResImage
                                                        }, failure: {(highResImageRequest, highResImageResponse, error) -> Void in })
                                                    })
                                                } else {
                                                    print("Image was cached, so just updated the image")
                                                    self.movieDetailImageView.image = image
                                                }
                                            },
                                             failure: {(imageRequest, imageResponse, error) -> Void in
                                                print("There was an error fetching the image!")
                                            })

            //movieDetailImageView.setImageWith(realImageURL!)
          }
        
        movieTitleLabel.text = movieTitleString
        movieOverviewLabel.text = movieOverviewString
        movieOverviewLabel.sizeToFit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
