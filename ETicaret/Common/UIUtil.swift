//
//  UIUtil.swift
//  ETicaret
//
//  Created by melisa öztürk on 3.10.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import Foundation
import UIKit

protocol UIUtilrDelegate {
    func showLoading(view: UIView)
    func removeLoading(view:UIView)
}

class UIUtil: UIUtilrDelegate {
    
    let loading = LoadingView()
    private static var sharedInstance: UIUtil?
    
    public class func shared() -> UIUtil {
        if sharedInstance == nil {
            sharedInstance = UIUtil()
        }
        return sharedInstance!
    }
    
    
    func showLoading(view: UIView) {
        view.addSubview(self.loading)
        view.isUserInteractionEnabled = false
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loading.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loading.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loading.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func removeLoading(view:UIView){
        view.isUserInteractionEnabled = true
        loading.removeFromSuperview()
    }
}
