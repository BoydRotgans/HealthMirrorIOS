//
//  ThumbnailCell.swift
//  ControllVideos
//
//  Created by Ferdinand Sorg on 10.02.20.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var videoCaption: UILabel!
    @IBOutlet weak var checkVideoPlay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
