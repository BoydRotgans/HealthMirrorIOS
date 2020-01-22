//
//  sendAttachedMail.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 22.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension ViewController: MFMailComposeViewControllerDelegate {
    // Send Mail
    @IBAction func sendEmail(_ sender: Any) {
//    func newMail() {
        
        let path = getDocumentsDirectory()
        let trackingData = path.appendingPathComponent("trackingData.csv").path
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("CSV File")
            mailComposer.setMessageBody("Here is the CSV File.", isHTML: false)
            mailComposer.setToRecipients(["post@ferdinands.org"])
            
            let url = URL(fileURLWithPath: trackingData)
            
            do {
            let attachmentData = try Data(contentsOf: url)
                mailComposer.addAttachmentData(attachmentData, mimeType: "text/csv", fileName: "trackingData")
                mailComposer.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
                self.present(mailComposer, animated: true
                    , completion: nil)
            } catch let error {
                print("We have encountered error \(error.localizedDescription)")
            }
            
        } else {
            print("Email is not configured in settings app or we are not able to send an email")
        }
    }
    
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
