//
//  RatingLong.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 22.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation

class RatingLong: UIViewController, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var questionCollectionView: UICollectionView!
    @IBOutlet weak var submitRatingLong: UIButton!
    
    var listOfQuestions = ["Hoe goed doet de cliënt mee?", "Hoe goed spiegelt de cliënt de bewegingen?", "Is de cliënt ontspannen?", "Is de cliënt vrolijker?", " Is de cliënt angstiger?"]
    var listOfLeft = ["niet goed", "niet goed", "niet ontspannen", "minder vrolijk", "minder angstig"]
    var listOfRight = ["goed", "goed", "ontspannen", "meer vrolijk", "meer angstig"]
    
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
        
//        self.dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "startScreen") as UIViewController
        vc.modalTransitionStyle = .flipHorizontal
        
        present(vc, animated: true, completion: nil)
        
        
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
        cell.LabelLeft.text = listOfLeft[indexPath.row]
        cell.LabelRight.text = listOfRight[indexPath.row]

        // tag rating with ID
        cell.questionRating.tag = indexPath.row

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected \(indexPath.item)")
    }
    
}
