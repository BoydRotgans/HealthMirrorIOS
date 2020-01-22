//
//  RatingCard.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 22.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation

class RatingCard: UIViewController {
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var submitRating: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reset float rating view's background color
        floatRatingView.backgroundColor = UIColor.clear

        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .wholeRatings

        // Labels init
        liveLabel.text = String(format: "%.0f", self.floatRatingView.rating)
        updatedLabel.text = String(format: "%.0f", self.floatRatingView.rating)
        
        submitRating.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        let rating = String(format: "%.0f", self.floatRatingView.rating)
        UserDefaults.standard.set(rating, forKey: "Rating")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension RatingCard: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        liveLabel.text = String(format: "%.0f", self.floatRatingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        updatedLabel.text = String(format: "%.0f", self.floatRatingView.rating)
    }
    
}
