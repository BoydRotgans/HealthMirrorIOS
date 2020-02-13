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
    @IBOutlet weak var submitRating: UIButton!
    
    @IBOutlet weak var extraQuestionLine: UILabel!
    @IBOutlet weak var extraButtonYes: UIButton!
    @IBOutlet weak var extraButtonNo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reset float rating view's background color
        self.floatRatingView.backgroundColor = UIColor.clear
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        self.floatRatingView.type = .wholeRatings
        
        submitRating.addTarget(self, action: #selector(self.submitButtonTapped), for: .touchUpInside)
        
        
        let id = UserDefaults.standard.integer(forKey: "videoID")
        let videoMeta = ViewController().getVideoMeta(id: id)
        
        var extraQuestion: String = ""
        
        if videoMeta.count >= 4 {
            print("videoMeta has \(videoMeta.count)")
            extraQuestion = videoMeta[3] as! String
        }
        
        // safe Question in UserDefaults
        UserDefaults.standard.set(extraQuestion, forKey: "extraQuestion")
        UserDefaults.standard.set("", forKey: "extraAnswer")
        
        if extraQuestion == "" {
            extraButtonYes.isHidden = true
            extraButtonNo.isHidden = true
            extraQuestionLine.isHidden = true
        } else {
            extraQuestionLine.text = extraQuestion
            extraButtonYes.layer.cornerRadius = 10.0
            extraButtonNo.layer.cornerRadius = 10.0
            extraButtonNo.backgroundImage(for: UIControl.State.selected)
            extraButtonYes.addTarget(self, action: #selector(self.extraButtonTapped), for: .touchUpInside)
            extraButtonNo.addTarget(self, action: #selector(self.extraButtonTapped), for: .touchUpInside)
        }
        
    }
    
    @objc func extraButtonTapped(sender: UIButton) {
        
        extraButtonNo.backgroundColor = .link
        extraButtonYes.backgroundColor = .link

        sender.backgroundColor = UIColor(named: "customGreen")
        
        let buttonAnswer = sender.currentTitle!
        
        // safe Question Answer
        UserDefaults.standard.set(buttonAnswer, forKey: "extraAnswer")
        
        print("buttonAnswer is \(buttonAnswer)")
    }
    
    @objc func submitButtonTapped(sender: UIButton) {
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
