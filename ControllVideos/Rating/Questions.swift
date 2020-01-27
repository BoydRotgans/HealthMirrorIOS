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
    }

}

extension Questions: FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {

        print("liveLabel")

        let liveLabel = String(format: "%.0f", questionRating.rating)

        print("liveLabel is \(liveLabel)")
    }

    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {

        print("updatedLabel")

        let updatedLabel = String(format: "%.0f", questionRating.rating)

        print("updatedLabel is \(updatedLabel)")
    }
}
