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
    
    
    var imageURL: String?
    @IBOutlet weak var movieDetailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realImageURL = URL(string: imageURL!)
        movieDetailImageView.setImageWith(realImageURL!)

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
