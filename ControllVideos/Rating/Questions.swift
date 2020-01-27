//
//  Questions.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 27.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class Questions: UICollectionViewCell {
    
    @IBOutlet weak var questionLine: UILabel!
    @IBOutlet weak var questionRating: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        questionRating.backgroundColor = UIColor.clear
        questionRating.delegate = self
        questionRating.contentMode = UIView.ContentMode.scaleAspectFit
        questionRating.type = .wholeRatings
    }

}

extension Questions: FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        let liveLabel = String(format: "%.0f", questionRating.rating)
//        print("liveLabel is \(liveLabel)")
        RatingLong().sendLiveRating(v: liveLabel)
    }

    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        let updatedLabel = String(format: "%.0f", questionRating.rating)
//        print("updatedLabel is \(updatedLabel)")
        
        RatingLong().sendUpdatedRating(v: updatedLabel)
    }

    

}
