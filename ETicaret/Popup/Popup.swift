//
//  Popup.swift
//  ETicaret
//
//  Created by melisa öztürk on 3.10.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import UIKit

protocol PopupDelegate {
    func saveData(viewController: UIViewController, product: Product)
}

class Popup: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var viewContent: UIView!
    
    var popupDelegate: PopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.navigationController?.isNavigationBarHidden = true
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func actionClose(_ sender: Any) {
        UIUtil.shared().removeFromView(viewController: self)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.popupDelegate?.saveData(viewController: self, product: Product(id: 0, title: self.txtTitle.text, category: self.txtCategory.text, price: Double(self.txtPrice.text!), description: self.txtViewDesc.text))
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
