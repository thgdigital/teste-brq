//
//  DetailView.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit
import RNActivityView

class DetailView: UICollectionViewController {
    
    var presenter: DetailPresenterInput!
    var cardItem: CarsItem = CarsItem()
    
    private lazy var descricaoCell: DescricaoCell = {
       return UINib(nibName: String(describing: DescricaoCell.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DescricaoCell
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLayout()
        self.presenter.find()
    }
    
    fileprivate func initialLayout() {
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        let nibName = UINib(nibName: "ThumbCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: ThumbCell.identifier)
        let nibNameDescricao = UINib(nibName: "DescricaoCell", bundle:nil)
        collectionView.register(nibNameDescricao, forCellWithReuseIdentifier: DescricaoCell.identifier)
        let nibNameCompra = UINib(nibName: "CompraCell", bundle:nil)
        collectionView.register(nibNameCompra, forCellWithReuseIdentifier: CompraCell.identifier)
      
        
    }
    
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.countItem
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbCell.identifier, for: indexPath) as! ThumbCell
            
            cell.populate(imageUrl: cardItem.imagem)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescricaoCell.identifier, for: indexPath) as! DescricaoCell
            cell.populate(display: CarsItemMapper.make(item: cardItem))
                       return cell
        default:
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompraCell.identifier, for: indexPath) as! CompraCell
           cell.delegate = self
          return cell
        }
        
        

    }
    
    
}
extension DetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
          return CGSize(width: view.frame.width, height: 135)
        case 1:
            descricaoCell.populate(display: CarsItemMapper.make(item: cardItem))
            descricaoCell.setNeedsLayout()
            descricaoCell.layoutIfNeeded()
            return descricaoCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .defaultLow)
        default:
            return CGSize(width: view.frame.width, height: 51)
        }
         
    }
}
extension DetailView: DetailPresenterOutput {
    
    func fetched(item: CarsItem) {
        cardItem = item
        collectionView.reloadData()
    }
    
    func error(type: ErrorType) {
        let title = "Opss Error"
        switch type {
        case .empty(let message):
            UIAlertController.showAlert(title: title, message: message, cancelButtonTitle: "Tentar Novamente", cancelBlock: { (alert) in
                self.presenter.retry()
            })
        case .serve(let message):
            UIAlertController.showAlert(title: title, message: message, cancelButtonTitle: "Tentar Novamente", cancelBlock: { (alert) in
                self.presenter.retry()
            })
        case .network(let message):
            UIAlertController.showAlert(title: title, message: message, cancelButtonTitle: "Tentar Novamente", cancelBlock: { (alert) in
                self.presenter.retry()
            })
        case .compraLimite(let message):
            UIAlertController.showAlert(title: title, message: message, cancelButtonTitle: "Fechar")
        }
    }
    
    func startLoading() {
        self.view.showActivityView()
    }
    
    func stopLoading() {
        self.view.hideActivityView()
    }
    func showSuccess(message: String){
        let title = "Dados Salvos"
        UIAlertController.showAlert(title: title, message: message, cancelButtonTitle: "Fechar")
    }
}
extension DetailView: CompraCellDelegate {
    func sendCompra(qtd: Int) {
        presenter.compra(with: qtd)
    }    
}
