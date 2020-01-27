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

    func sendLiveRating(v: String) {
        print("Live is \(v)")
    }
    
    func sendUpdatedRating(v: String) {
        print("Updated is \(v)")
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

        print("rating \(indexPath.row) is \(cell.questionRating.rating)")
        
        if(cell.questionRating.isFocused) {
            print("self is focused \(indexPath.row)")
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected \(indexPath.item)")
    }
}
