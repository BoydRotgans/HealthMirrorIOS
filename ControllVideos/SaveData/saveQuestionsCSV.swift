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
    
    
    
//    loadAndShare()
    
    
    
    // share generated file
//    print("share generated file")
//
//    let str = RatingLong().descriptionText.text
////    var filename = getDocumentsDirectory().stringByAppendingPathComponent("questionData.csv")
//    var filename = (getDirectoryPath() as NSString).appendingPathComponent("questionData.csv")
//    
//    do {
//        try str.writeToFile(filename!, atomically: true, encoding: NSUTF8StringEncoding)
//
//        let fileURL = NSURL(fileURLWithPath: filename)
//
//        let objectsToShare = [fileURL]
//        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//        RatingLong().present(activityVC, animated: true, completion: nil)
//
//    } catch {
//        print("cannot write file")
//        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//    }
}

//func getDirectoryPath() -> String { let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//    let documentsDirectory = paths[0]
//    return documentsDirectory
//}
//
//func loadAndShare() {
//    print("load and share")
//
//    let fileManager = FileManager.default
//    let documentoPath = (getDirectoryPath() as NSString).appendingPathComponent("questionData.csv")
//
//    print("documentoPath is \(documentoPath)")
//
//    if fileManager.fileExists(atPath: documentoPath){
//        let documento = NSData(contentsOfFile: documentoPath)
//        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView=RatingLong().view
//        RatingLong().present(activityViewController, animated: true, completion: nil)
//    }
//    else {
//        print("document was not found")
//    }
//}
