//
//  MylistView.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


class MylistView: UICollectionViewController {
    var cars: [CarsItem] = [CarsItem]()
    
    var presenter: MylistInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLayout()
        presenter.fetch()
    }
    
    fileprivate func initialLayout() {
        navigationItem.title = "Cesta de compras"
        collectionView.backgroundColor = .white
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        let nibName = UINib(nibName: "CarCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: CarCell.identifier)
        let nibNameLoading = UINib(nibName: "LoadingCell", bundle:nil)
        collectionView.register(nibNameLoading, forCellWithReuseIdentifier: LoadingCell.identifier)
        let nibNameFooterView = UINib(nibName: "FooterView", bundle:nil)
        collectionView.register(nibNameFooterView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterView.identifier)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cars.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCell.identifier, for: indexPath) as! CarCell
        cell.populate(display: CarsItemMapper.make(item: cars[indexPath.row]), type: .remove, indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
    
    
    
}

extension MylistView: UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var texto = "Olá sua cesta esta vazia :("
        var  attributedString: NSAttributedString = NSAttributedString()
        
        if let paragraphStyle = NSParagraphStyle.default.mutableCopy() as?  NSMutableParagraphStyle {
            paragraphStyle.lineHeightMultiple = 1.2
            paragraphStyle.alignment = .center
            attributedString = NSMutableAttributedString(string: texto, attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.70), .paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 17)])
        }
        return attributedString
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let texto = "Minha lista"
               var  attributedString: NSAttributedString = NSAttributedString()
               
               if let paragraphStyle = NSParagraphStyle.default.mutableCopy() as?  NSMutableParagraphStyle {
                   paragraphStyle.lineHeightMultiple = 1.2
                   paragraphStyle.alignment = .center
                   attributedString = NSMutableAttributedString(string: texto, attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.70), .paragraphStyle: paragraphStyle, .font: UIFont.systemFont(ofSize: 17)])
               }
               return attributedString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty_cart")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if cars.isEmpty {
            return .zero
        }
        return CGSize(width: view.frame.width, height: 80)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterView.identifier, for: indexPath) as! FooterView
        footer.delegate = self
        return footer
    }
    
}

extension MylistView: MylistOuput {
    func fetched(cars: [CarsItem]) {
        self.cars = cars
        collectionView.reloadData()
    }
    
    
}

extension MylistView: CarCellDelegate, FooterViewDelegate {
    
    func sendCompra() {
        presenter.sendCompra()
    }
    
    func didSelected(type: CarCellType, indexPath: IndexPath) {
        presenter.remove(with: cars[indexPath.row])
    }
    
}
