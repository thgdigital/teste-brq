//
//  FooterView.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {
    
    weak var delegate: FooterViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func sendCompra(_ sender: Any) {
        delegate?.sendCompra()
    }
    
}
protocol FooterViewDelegate: class {
    func sendCompra()
}
