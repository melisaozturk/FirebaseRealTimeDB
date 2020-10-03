//
//  UIUtil.swift
//  ETicaret
//
//  Created by melisa öztürk on 3.10.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import Foundation
import UIKit

protocol UIUtilDelegate {
    func showLoading(viewController: UIViewController)
    func removeLoading(viewController: UIViewController)
}

class UIUtil: UIUtilDelegate {
    
    let loading = LoadingView()
    private static var sharedInstance: UIUtil?
    
    public class func shared() -> UIUtil {
        if sharedInstance == nil {
            sharedInstance = UIUtil()
        }
        return sharedInstance!
    }
    
    
    func showLoading(viewController: UIViewController) {
        viewController.view.addSubview(self.loading)
        viewController.view.isUserInteractionEnabled = false
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        loading.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        loading.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        loading.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        viewController.navigationController?.isNavigationBarHidden = true
    }
    
    func removeLoading(viewController: UIViewController){
        viewController.view.isUserInteractionEnabled = true
        loading.removeFromSuperview()
        viewController.navigationController?.isNavigationBarHidden = false
    }
    
    func removeFromView(viewController: UIViewController) {
        UIView.animate(withDuration: 0.2, animations: {
            viewController.view.alpha = 0.0
        }) { (isClose: Bool) in
            if isClose {
                viewController.view.removeFromSuperview()
                viewController.navigationController?.isNavigationBarHidden = false
            }
        }
    }
}
