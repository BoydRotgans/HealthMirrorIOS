//
//  ItemCell.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 21/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(text: String) {
        self.textLabel.text = text
    }
    
    

}
