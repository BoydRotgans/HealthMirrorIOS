//
//  saveQuestionsCSV.swift
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
    
    // define Headerline
    var header = ["ID", "sessionID", "timestamp"]
    
    for (index, _) in questionRatingData.enumerated() {
        header.append("Question \(index+1)")
    }
    
    // get meta Data
    let metaData = [String(ID), sessionID, timestamp]
    let formattedQuestionRatingData:Array<String> = questionRatingData.map(String.init)
    
    // array of data to save
    let completeDataString = metaData + formattedQuestionRatingData
    
    // get path + file
    let path = getDocumentsDirectory()
    let trackingData = path.appendingPathComponent("questionData.csv")
    
    // check if exist
    let exists = FileManager.default.fileExists(atPath: trackingData.path)
    let writeStream = OutputStream(url: trackingData, append: true)!
    let writeCSV = try! CSVWriter(stream: writeStream)
    
    if !exists {
        try! writeCSV.write(row: header)
    }
    
    // crate file and write header row
    try! writeCSV.write(row: completeDataString)
    
    let data = [UInt8](writeCSV.configuration.newline.utf8)
    writeCSV.stream.write(data, maxLength: data.count)
    
    writeCSV.stream.close()
}
