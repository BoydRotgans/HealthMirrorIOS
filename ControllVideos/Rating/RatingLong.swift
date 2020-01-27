//
//  RatingLong.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 22.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation

class RatingLong: UIViewController {
    
    
    @IBOutlet weak var questionCollectionView: UICollectionView!
    @IBOutlet weak var submitRatingLong: UIButton!
    
    var listOfQuestions = ["Lorem ipsum dolor sit amet, amet amet et, est eu justo?", "Semper viverra nulla, aliquam quis?", "Et quis, urna nulla mauris, ornare in morbi?", "Ullamcorper fringilla tristique, nam sociosqu et?", "Egestas volutpat suspendisse, donec consequat nec?"]
    
    var questionRating = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionCollectionView.delegate = self
        self.questionCollectionView.dataSource = self
        self.questionCollectionView.allowsSelection = true
        
        self.questionCollectionView.register(UINib(nibName: "Questions", bundle: nil), forCellWithReuseIdentifier: "Questions")
        
        submitRatingLong.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        print("submitted")
    }
}

extension RatingLong: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfQuestions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as! Questions

        cell.questionLine.text = listOfQuestions[indexPath.row]

        print("rating at \(indexPath.row) is \(cell.questionRating.rating)")

        questionRating = cell.questionRating.rating

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected \(indexPath.item)")
        
        
    }
    
}

extension RatingLong: FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {

        print("liveLabel")

        let liveLabel = String(format: "%.0f", rating)

        print("liveLabel is \(liveLabel)")
    }

    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {

        print("updatedLabel")

        let updatedLabel = String(format: "%.0f", rating)

        print("updatedLabel is \(updatedLabel)")
    }
}
