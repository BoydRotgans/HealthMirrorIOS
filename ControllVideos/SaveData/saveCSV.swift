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
    
func checkAllData() {
    // get ID
    var ID = UserDefaults.standard.object(forKey: "ID") as? Int ?? 0
    ID += 1
    UserDefaults.standard.set(ID, forKey: "ID")
    
    // get sessionID
    let sessionID = UserDefaults.standard.string(forKey: "sessionID") ?? "no sessionID data"
    
    // get timestamp
    let timestamp = UserDefaults.standard.string(forKey: "startVideoPlayTimestamp") ?? "no startVideoPlayTimestamp data"
    
    //get user
//    let randomUser = ["Suellen", "Rita", "Jamika", "Minh", "Tenesha"]
//    let user = randomUser[Int.random(in: 0 ..< 5)]
    let user = UserDefaults.standard.string(forKey: "selectedUser") ?? "no user data"
    
    // get type
    let location = UserDefaults.standard.string(forKey: "selectedType") ?? "no location data"
    
    //get video
    let video = UserDefaults.standard.string(forKey: "video") ?? "no video data"
    
    // get rating
    let rating = UserDefaults.standard.string(forKey: "rating") ?? "no rating data"
    
    // get duration
    let duration = UserDefaults.standard.string(forKey: "duration") ?? "no duration data"
    
    // get videoType
    var videoType:String
    let animationStatus = UserDefaults.standard.bool(forKey: "animationStatus")
    switch animationStatus {
    case true:
        videoType = "animation"
    case false:
        videoType = "normal"
    }
    
    // get extra Question
    let extraQuestion = UserDefaults.standard.string(forKey: "extraQuestion") ?? "no extraQuestion data"
    let extraAnswer = UserDefaults.standard.string(forKey: "extraAnswer") ?? "no extraAnswer data"
    
    saveInCSV(ID: ID, sessionID: sessionID, timestamp: timestamp, user: user, location: location, video: video, duration: duration, videoType: videoType, rating: rating, extraQuestion: extraQuestion, extraAnswer: extraAnswer)
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func saveInCSV(ID: Int, sessionID: String, timestamp: String, user: String, location: String, video: String, duration: String, videoType: String, rating: String, extraQuestion: String, extraAnswer: String) {
        
    // get path + file
    let path = getDocumentsDirectory()
    let trackingData = path.appendingPathComponent("trackingData.csv")
    
    // check if exist
    let exists = FileManager.default.fileExists(atPath: trackingData.path)
    let writeStream = OutputStream(url: trackingData, append: true)!
    let writeCSV = try! CSVWriter(stream: writeStream)
    
    if !exists {
        try! writeCSV.write(row: ["ID", "sessionID", "timestamp", "user", "location", "video", "duration", "videoType", "rating", "extraQuestion", "extraAnswer"])
    }
    
    // crate file and write header row
    try! writeCSV.write(row: [String(ID), sessionID, timestamp, user, location, video, duration, videoType, rating, extraQuestion, extraAnswer])
    
    let data = [UInt8](writeCSV.configuration.newline.utf8)
    writeCSV.stream.write(data, maxLength: data.count)
    
    writeCSV.stream.close()
}
