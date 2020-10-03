//
//  Popup.swift
//  ETicaret
//
//  Created by melisa öztürk on 3.10.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import UIKit

protocol PopupDelegate {
    func saveData(viewController: UIViewController)
}

class Popup: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var viewContent: UIView!
    
    var popupDelegate: PopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func actionClose(_ sender: Any) {
        UIUtil.shared().removeFromView(viewController: self)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.popupDelegate?.saveData(viewController: self)
    }
}
