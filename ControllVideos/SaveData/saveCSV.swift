//
//  SaveInCSV.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 20.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation
import CSV
    
func checkAllData() {
    // get timestamp
    let now = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy_MM_dd-HH:mm:ss"
    let timestamp = formatter.string(from: now)
    
    //get user
    let randomUser = ["Suellen", "Rita", "Jamika", "Minh", "Tenesha"]
    let user = randomUser[Int.random(in: 0 ..< 5)]
    
    // get rating
    let rating = UserDefaults.standard.string(forKey: "Rating") ?? "Unknown user"
    
    saveInCSV(timestamp: timestamp, user: user, rating: rating)
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func saveInCSV(timestamp: String, user: String, rating: String) {
        
    // get path + file
    let path = getDocumentsDirectory()
    let trackingData = path.appendingPathComponent("trackingData.csv")
    
    // check if exist
    let exists = FileManager.default.fileExists(atPath: trackingData.path)
    let writeStream = OutputStream(url: trackingData, append: true)!
    let writeCSV = try! CSVWriter(stream: writeStream)
    
    if !exists {
        try! writeCSV.write(row: ["timestamp", "user", "rating"])
    }
    
    // write new row
    try! writeCSV.write(row: [timestamp, user, rating])
    
    let data = [UInt8](writeCSV.configuration.newline.utf8)
    writeCSV.stream.write(data, maxLength: data.count)
    
    writeCSV.stream.close()
}
