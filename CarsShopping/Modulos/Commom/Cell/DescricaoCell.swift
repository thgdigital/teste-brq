//
//  DescricaoCell.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit

class DescricaoCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var withConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var valorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        withConstraint.constant = UIScreen.main.bounds.width
    }

    func populate(display: CarDisplay) {
        nameLabel.text = display.nome
        textLabel.text = display.descricao
        valorLabel.text = display.preco
    }
}
