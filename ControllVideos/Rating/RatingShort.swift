//
//  RatingShort.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 22.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation

class RatingShort: UIViewController {
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
//    @IBOutlet weak var liveLabel: UILabel!
//    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var submitRating: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reset float rating view's background color
        self.floatRatingView.backgroundColor = UIColor.clear

        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.floatRatingView.type = .wholeRatings

        // Labels init
//        liveLabel.text = String(format: "%.0f", self.floatRatingView.rating)
//        updatedLabel.text = String(format: "%.0f", self.floatRatingView.rating)
        
        submitRating.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        let rating = String(format: "%.0f", self.floatRatingView.rating)
        UserDefaults.standard.set(rating, forKey: "rating")
        UserDefaults.standard.set(true, forKey: "hasRating")
        
        // save in CSV
        checkAllData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension RatingShort: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
//        liveLabel.text = String(format: "%.0f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
//        updatedLabel.text = String(format: "%.0f", self.floatRatingView.rating)
    }
    
}
