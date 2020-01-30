//
//  generateZipFile.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 29.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation

func generateZipFile() {
    
    // get timestamp
    let now = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
    let timestamp = formatter.string(from: now)
    
    
    let fileManager = FileManager.default
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
    var sourceURL = URL(fileURLWithPath: path)
    sourceURL.appendPathComponent("")
    
    print("sourceURL is \(sourceURL)")
    
    var destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    destinationURL.appendPathComponent("dataPackage-\(timestamp).zip")
    
    do {
        try fileManager.zipItem(at: sourceURL, to: destinationURL, shouldKeepParent: false)
        
        print("zip is generated")
        
        UserDefaults.standard.set(destinationURL, forKey: "ZipFileURL")
        
    } catch {
        print(error)
    }
    
}
