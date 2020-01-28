//
//  Questions.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 27.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class Questions: UICollectionViewCell {
    
    var arrayOfRatings:Array<Int> = []
    
    @IBOutlet weak var questionLine: UILabel!
    @IBOutlet weak var questionRating: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let numberOfQuestions = RatingLong().listOfQuestions.count
        arrayOfRatings = Array(repeating: 0, count: numberOfQuestions)
        
        UserDefaults.standard.set(arrayOfRatings, forKey: "QuestionRating")
        
        questionRating.backgroundColor = UIColor.clear
        questionRating.delegate = self
        questionRating.contentMode = UIView.ContentMode.scaleAspectFit
        questionRating.type = .wholeRatings
    }

}

extension Questions: FloatRatingViewDelegate {
//    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
//        let liveLabel = String(format: "%.0f", questionRating.rating)
//        print("liveLabel is \(liveLabel)")
//    }

    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        let updatedLabel = Int(questionRating.rating)
        let questionID = questionRating.tag
        
        // read Rating from UserDefaults
        arrayOfRatings = (UserDefaults.standard.array(forKey: "QuestionRating") as? [Int])!
        
        // update Rating Array from UserDefaults
        arrayOfRatings[questionID] = updatedLabel
        
        // write updated Rating to UserDefaults
        UserDefaults.standard.set(arrayOfRatings, forKey: "QuestionRating")
        
        print("arrayOfRatings is \(arrayOfRatings)")
    }
}
