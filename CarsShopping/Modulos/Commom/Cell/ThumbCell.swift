//
//  ThumbCell.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit
import SDWebImage

class ThumbCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(imageUrl: String) {
        thumbImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
    }

}
