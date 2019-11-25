//
//  HomeListView.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit
import RNActivityView

class HomeListView: UICollectionViewController {
    
    var presenter: HomeListInput!
    
    var cars: [CarsItem] = [CarsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchCars()
        initialLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cars.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cars[indexPath.row] is CarsItemLoading {
            return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCell.identifier, for: indexPath) as! CarCell
            cell.populate(display: CarsItemMapper.make(item: cars[indexPath.row]), type: .compra, indexPath: indexPath)
            cell.delegate = self
            return cell
        }
        
    }
    
    fileprivate func initialLayout() {
        navigationItem.title = "Lista de carros"
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        let nibName = UINib(nibName: "CarCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: CarCell.identifier)
        let nibNameLoading = UINib(nibName: "LoadingCell", bundle:nil)
        collectionView.register(nibNameLoading, forCellWithReuseIdentifier: LoadingCell.identifier)
        let infoButton = UIButton(type: .infoLight)

        // You will need to configure the target action for the button itself, not the bar button itemr
        infoButton.addTarget(self, action: #selector(infoAction), for: .touchUpInside)

        // Create a bar button item using the info button as its custom view
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)

        // Use it as required
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    @objc func infoAction () {
        presenter.showMylist()
    }
    
}

extension HomeListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 135)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is LoadingCell {
            presenter.paginate()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelected(with: cars[indexPath.row])
    }
}

extension HomeListView: CarCellDelegate {
    func didSelected(type: CarCellType, indexPath: IndexPath) {
        presenter.sendCompra(with: cars[indexPath.row])
    }
}

extension HomeListView: HomeListOutput {
    
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
    
    func showSuccess(message: String){
        let title = "Dados Salvos"
        UIAlertController.showAlert(title: title, message: message, cancelButtonTitle: "Fechar")
    }
    
    func fetched(cars: [CarsItem]) {
        self.cars = cars
        collectionView.reloadData()
    }
    
    func fetched(paginate cars: [CarsItem]) {
        self.cars = cars
        collectionView.reloadItemsInSection(sectionIndex: 0, newCount: self.cars.count) {
            let indexPathsForVisibleItems = self.collectionView.indexPathsForVisibleItems
            self.collectionView.reloadItems(at: indexPathsForVisibleItems)
        }
    }
    
    func startLoading() {
        self.view.showActivityView()
    }
    
    func stopLoading() {
        self.view.hideActivityView()
    }
}
