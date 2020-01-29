//
//  sendAttachedMail.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 22.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation
import UIKit
import CSV
import ZIPFoundation
import MessageUI

extension UserBoardViewController: MFMailComposeViewControllerDelegate {
    // Send Mail
    
    @objc func sendEmail() {
        
        print("hi im mailing")

        let path = getDocumentsDirectory()
        let trackingData = path.appendingPathComponent("questionData.csv").path
//        let dataPackage = path.appendingPathComponent("dataPackage-\(timestamp).zip").path
        

        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("CSV File")
            mailComposer.setMessageBody("Here is the CSV File.", isHTML: false)
            mailComposer.setToRecipients(["post@ferdinands.org"])

            let url = URL(fileURLWithPath: trackingData)

            do {
            let attachmentData = try Data(contentsOf: url)
//                mailComposer.addAttachmentData(attachmentData, mimeType: "application/zip", fileName: "dataPackage")
                mailComposer.addAttachmentData(attachmentData, mimeType: "text/csv", fileName: "trackingData")
//                mailComposer.addAttachmentData(attachmentData, mimeType: "text/csv", fileName: "questionData")
//                mailComposer.addAttachmentData(attachmentData, mimeType: "text/csv", fileName: "userList")
                mailComposer.mailComposeDelegate = self
                self.present(mailComposer, animated: true
                    , completion: nil)
            } catch let error {
                print("We have encountered error \(error.localizedDescription)")
            }

        } else {
            print("Email is not configured in settings app or we are not able to send an email")
        }
    }
    
//    func zipData(timestamp: String) {
//
//        let fileManager = FileManager.default
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
//        var sourceURL = URL(fileURLWithPath: path)
//        sourceURL.appendPathComponent("")
//
//        print("sourceURL is \(sourceURL)")
//
//        var destinationURL = URL(fileURLWithPath: path)
//        destinationURL.appendPathComponent("dataPackage-\(timestamp).zip")
//        do {
//            try fileManager.zipItem(at: sourceURL, to: destinationURL, shouldKeepParent: false)
//
//            print("nice")
//        } catch {
//            print(error)
//        }
//
//    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("User cancelled")
            break

        case .saved:
            print("Mail is saved by user")
            break

        case .sent:
            print("Mail is sent successfully")
            break

        case .failed:
            print("Sending mail is failed")
            break
        default:
            break
        }
        controller.dismiss(animated: true)
    }
}
