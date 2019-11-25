//
//  CompraCell.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit

class CompraCell: UICollectionViewCell {
    var value: Int = 0
    
    @IBOutlet weak var qtdLabel: UILabel!
    
    @IBAction func send(_ sender: UIStepper) {
        value = Int(sender.value)
        qtdLabel.text = "Quantidade: \(value)"
         
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
