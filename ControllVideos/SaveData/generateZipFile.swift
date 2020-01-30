//
//  generateZipFile.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 29.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation

func generateZipFile() {
    
    let fileManager = FileManager.default
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
    var sourceURL = URL(fileURLWithPath: documentPath)
    sourceURL.appendPathComponent("")
    
    var destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    destinationURL.appendPathComponent("dataPackage.zip")
    
    // delete previous version
    if fileManager.fileExists(atPath: destinationURL.path) {
        do {
            try FileManager.default.removeItem(at: destinationURL)
            
            print("previous version was deleted")
            
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
        
    } else {
        print("file does not exist")
    }
    
    // generate new version
    do {
        try fileManager.zipItem(at: sourceURL, to: destinationURL, shouldKeepParent: false)
        
        print("zip is generated")
        
        UserDefaults.standard.set(destinationURL, forKey: "ZipFileURL")
        
    } catch {
        print(error)
    }
    
}
