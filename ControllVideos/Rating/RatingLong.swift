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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionCollectionView.delegate = self
        self.questionCollectionView.dataSource = self
        self.questionCollectionView.allowsSelection = true
        
        self.questionCollectionView.register(UINib(nibName: "Questions", bundle: nil), forCellWithReuseIdentifier: "Questions")
        
        submitRatingLong.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        let finalRating = UserDefaults.standard.array(forKey: "QuestionRating") as? [Int] ?? [Int]()
        
        checkQuestionData()
        
        print("submitted with Rating: \(finalRating)")
        
        self.dismiss(animated: true, completion: nil)
        
//        for (index, rating) in finalRating.enumerated() {
//            finalRating[index] = 0
//        }
//
//        print("resetet Rating: \(finalRating)")
    }
}

extension RatingLong: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfQuestions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as! Questions

        // show question
        cell.questionLine.text = listOfQuestions[indexPath.row]

        // tag rating with ID
        cell.questionRating.tag = indexPath.row

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected \(indexPath.item)")
    }
    
}
