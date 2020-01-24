//
//  UserBoardViewController.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 21/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation
import CSV

class UserBoardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addUserButton: UIButton!
    
    
    var dataArray = [] as [String]
    
    var estimateWidth = 160.0
    var cellMarginSize = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegates
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsSelection = true
        
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        
        // check if csv file excist
        let path = getDocumentsDirectory()
        let usersList = path.appendingPathComponent("usersList.csv")
        
        if FileManager.default.fileExists(atPath: usersList.path) == false { // if file is not there
            print("we got no file!")
            let stream = OutputStream(toFileAtPath: usersList.path, append: false)!
            let csv = try! CSVWriter(stream: stream)
            try! csv.write(row: ["id", "name"])
            csv.stream.close()
        }
               
        // read csv
        let readStream = InputStream(url: usersList)!
        let readCSV = try! CSVReader(stream: readStream, hasHeaderRow: true)
        
        while readCSV.next() != nil {
            let name = readCSV["name"]! as String
            dataArray.append(name)
        }
        
        // button click
        addUserButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        // setupGride view
        self.setupGridView()
    }
    
    
    
    @objc func buttonPressed() {
        
        let alert = UIAlertController(title: "New user", message: "Please enter a new username", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let name = textField?.text!
            self.writeNewRow(name: name!)
            self.dataArray.append(name!)
            self.setupGridView()
            self.collectionView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func writeNewRow(name: String) {
       let path = getDocumentsDirectory()
       let usersList = path.appendingPathComponent("usersList.csv")
        
       let writeStream = OutputStream(url: usersList, append: true)!
       let writeCSV = try! CSVWriter(stream: writeStream)
        
       if(dataArray.count == 0) { // correction for first write
            try! writeCSV.write(row: [""])
       }
        
       try! writeCSV.write(row: [String(dataArray.count), name])
       let data = [UInt8](writeCSV.configuration.newline.utf8)
       writeCSV.stream.write(data, maxLength: data.count)
       writeCSV.stream.close()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
}


extension UserBoardViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
        let selection = self.dataArray[indexPath.row]
        print(selection)
        UserDefaults.standard.set(selection, forKey: "selectedUser")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TypeViewController") as! UiTypeView
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
}

extension UserBoardViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.dataArray.count)
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.setData(text: self.dataArray[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//           print(indexPath.item)
//    }
       
    
}



extension UserBoardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(self.estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = ((self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount)
        
        return width
    }
    
    
}
