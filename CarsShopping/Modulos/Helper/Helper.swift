//
//  Helper.swift
//  CarsShopping
//
//  Created by Thiago Vaz on 21/11/19.
//  Copyright © 2019 Thiago Vaz. All rights reserved.
//

import UIKit

protocol Identifier{}

extension Identifier where Self: NSObject{
    
    static var identifier: String { return String(describing: self) }
}

extension NSObject: Identifier {}

extension UICollectionView {
    
    func reloadItemsInSection(sectionIndex: Int, newCount: Int? = nil, completion: (() -> Void)?) {
        self.performBatchUpdates({
            
            self.collectionViewLayout.invalidateLayout()
            
            var sectionItemsCount: Int = 0
            let collectionView: UICollectionView = self
            
            sectionItemsCount = collectionView.numberOfItems(inSection: sectionIndex)
            
            let countArray = [sectionItemsCount, newCount ?? 0]
            let maxCount = countArray.max() ?? 0
            let minCount = countArray.min() ?? 0
            
            var changed = [IndexPath]()
            for i in minCount..<maxCount {
                let indexPath = IndexPath(row: i, section: sectionIndex)
                changed.append(indexPath)
            }
            
            if (newCount ?? 0) > sectionItemsCount {
                collectionView.insertItems(at: changed)
                
            } else if sectionItemsCount > (newCount ?? 0) {
                collectionView.deleteItems(at: changed)
            }
            
        }, completion:  { _ in
            self.collectionViewLayout.invalidateLayout()
            
            //      self.reloadLoadingCells(section: section)
            completion?()
        })
    }
    
}

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if let navigationController = vc as? UINavigationController,
            let visibleController = navigationController.visibleViewController  {
            return UIWindow.getVisibleViewControllerFrom( vc: visibleController )
        } else if let tabBarController = vc as? UITabBarController,
            let selectedTabController = tabBarController.selectedViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: selectedTabController )
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}


extension UIAlertController {
    
    func show(_ viewController: UIViewController? = nil) {
        
        let topViewController = viewController ?? UIApplication.shared.keyWindow?.visibleViewController()
        
        topViewController?.present(self, animated: true, completion: nil)
    }
    
    static func showAlert(title: String, message: String, cancelButtonTitle: String? = nil,
                          confirmationButtonTitle: String? = nil, viewController: UIViewController? = nil,
                          dismissBlock: ((_ textField: [UITextField]? , _ action: UIAlertAction)-> Void)? = nil ,
                          cancelBlock: ((UIAlertAction)-> Void)? = nil, email: ((UITextField) -> Void)? = nil, password: ((UITextField) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if email != nil {
            alert.addTextField(configurationHandler: email)
        }
        
        if password != nil {
            alert.addTextField(configurationHandler: password)
        }
        
        // Cancel Button
        if cancelButtonTitle != nil {
            alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
                cancelBlock?(action)
            }))
        }
        // Confirmation button
        if confirmationButtonTitle != nil {
            
            alert.addAction(UIAlertAction(title: confirmationButtonTitle, style: UIAlertAction.Style.default, handler: { (action) -> Void in
                dismissBlock?(alert.textFields, action)
            }))
        }
        
        // Show
        DispatchQueue.main.async {
            alert.show(viewController)
        }
    }
}
