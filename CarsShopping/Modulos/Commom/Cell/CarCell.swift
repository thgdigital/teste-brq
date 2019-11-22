//
//  CarCell.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 22/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit
import SDWebImage

enum CarCellType {
    case compra
    case remove
}

class CarCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtdLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    var type: CarCellType = .compra
    
    @IBOutlet weak var sendButton: UIButton!
    
    func populate(display: CarDisplay, type: CarCellType) {
        titleLabel.text = display.nome
        priceLabel.text = display.preco
        self.type = type
        thumbImageView.sd_setImage(with: URL(string: display.imagem), completed: nil)
        qtdLabel.isHidden = display.isQtd
        qtdLabel.text = display.quantidade

    }
    
    @IBAction func actionSend(_ sender: Any) {
        
    }
    
     override func awakeFromNib() {
        super.awakeFromNib()
        sendButton.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        priceLabel.text = nil
        thumbImageView.sd_cancelCurrentImageLoad()
    }

}
