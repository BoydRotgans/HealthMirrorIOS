//
//  saveCSV.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 20.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation
import CSV
    
func checkQuestionData() {
    
    // get ID
    var ID = UserDefaults.standard.object(forKey: "QuestionID") as? Int ?? 0
    ID += 1
    UserDefaults.standard.set(ID, forKey: "QuestionID")
    
    // get sessionID
    let sessionID = UserDefaults.standard.string(forKey: "sessionID") ?? "no sessionID data"
    
    // get timestamp
    let now = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timestamp = formatter.string(from: now)
    
    // get Question Rating
    let questionRatingData = UserDefaults.standard.array(forKey: "QuestionRating") as? [Int] ?? [Int]()
    
    // get path + file
    let path = getDocumentsDirectory()
    let trackingData = path.appendingPathComponent("questionData.csv")
    
    // check if exist
    let exists = FileManager.default.fileExists(atPath: trackingData.path)
    let writeStream = OutputStream(url: trackingData, append: true)!
    let writeCSV = try! CSVWriter(stream: writeStream)
    
    if !exists {
        try! writeCSV.write(row: ["ID", "sessionID", "timestamp", "Question 1", "Question 2", "Question 3", "Question 4", "Question 5"])
    }
    
    // crate file and write header row
    try! writeCSV.write(row: [String(ID), sessionID, timestamp, String(questionRatingData[0]), String(questionRatingData[1]), String(questionRatingData[2]), String(questionRatingData[3]), String(questionRatingData[4])])
    
    let data = [UInt8](writeCSV.configuration.newline.utf8)
    writeCSV.stream.write(data, maxLength: data.count)
    
    writeCSV.stream.close()
}
