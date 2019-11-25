//
//  MylistView.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 25/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit


class MylistView: UICollectionViewController {
     var cars: [CarsItem] = [CarsItem]()
    
    var presenter: MylistInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialLayout()
        presenter.fetch()
    }
    
    fileprivate func initialLayout() {
           collectionView.backgroundColor = .white
           collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
           let nibName = UINib(nibName: "CarCell", bundle:nil)
           collectionView.register(nibName, forCellWithReuseIdentifier: CarCell.identifier)
           let nibNameLoading = UINib(nibName: "LoadingCell", bundle:nil)
           collectionView.register(nibNameLoading, forCellWithReuseIdentifier: LoadingCell.identifier)
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

extension MylistView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 135)
    }
}

extension MylistView: MylistOuput {
    func fetched(cars: [CarsItem]) {
        self.cars = cars
        collectionView.reloadData()
    }
    
    
}
extension MylistView: CarCellDelegate {
    func didSelected(type: CarCellType, indexPath: IndexPath) {
        presenter.remove(with: cars[indexPath.row])
    }
}
