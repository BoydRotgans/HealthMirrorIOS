//
//  generateZipFile.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 29.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation

extension UserBoardViewController {
    
    func generateZipFile() -> Bool {
        
        var status = false
        var success = false
        
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
                
                success = true
                print("previous version was deleted")
                
                
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
            
        } else {
            success = true
            print("file does not exist")
        }
        
        if success {
            do {
                try FileManager.default.zipItem(at: sourceURL, to: destinationURL, shouldKeepParent: false)
                
                status = true
                print("zip is generated")
                UserDefaults.standard.set(destinationURL, forKey: "ZipFileURL")

                self.endLoading(success: status)
                
            } catch {
                print(error)
            }
        }
        
        return status
    }
}
