//
//  ListOfVideos.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 23.01.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit
import Foundation

class ListOfVideos: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(listOfVideos.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = listOfVideos[indexPath.row]
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did selected \(indexPath.row) should be \(listOfVideos[indexPath.row])")
        ViewController().playVideo(id: indexPath.row)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
