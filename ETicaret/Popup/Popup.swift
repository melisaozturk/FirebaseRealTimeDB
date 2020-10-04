//
//  Popup.swift
//  ETicaret
//
//  Created by melisa öztürk on 3.10.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import UIKit

protocol PopupDelegate {
    func saveData(viewController: UIViewController, product: Product, index: Int?)
}

class Popup: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var viewContent: UIView!
    
    var popupDelegate: PopupDelegate?
    var index: Int?
    var products: [Product]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.navigationController?.isNavigationBarHidden = true
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.checkIndex()
    }

    @IBAction func actionClose(_ sender: Any) {
        Util.shared().removeFromView(viewController: self)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if index == nil {
            if !self.txtTitle.text!.isEmpty && !self.txtCategory.text!.isEmpty && !self.txtPrice.text!.isEmpty && !self.txtViewDesc.text!.isEmpty {
                self.popupDelegate?.saveData(viewController: self, product: Product(title: self.txtTitle.text, category: self.txtCategory.text, price: self.txtPrice.text!.toDouble(), description: self.txtViewDesc.text), index: nil)
            } else {
                let alert = UIAlertController(title: "Uyarı", message: "Boş alan bırakmayınız", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.view.endEditing(true)
                })
                alert.addAction(actionOk)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if !self.txtTitle.text!.isEmpty && !self.txtCategory.text!.isEmpty && !self.txtPrice.text!.isEmpty && !self.txtViewDesc.text!.isEmpty {
                self.popupDelegate?.saveData(viewController: self, product: Product(title: self.txtTitle.text, category: self.txtCategory.text, price: self.txtPrice.text!.toDouble(), description: self.txtViewDesc.text), index: self.index)
            } else {
                let alert = UIAlertController(title: "Uyarı", message: "Boş alan bırakmayınız", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.view.endEditing(true)
                })
                alert.addAction(actionOk)
                self.present(alert, animated: true, completion: nil)
            }
        }
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
    
    private func checkIndex() {
        if index != nil {
            self.txtTitle.text = self.products[self.index!].title
            self.txtCategory.text = self.products[self.index!].category
            self.txtPrice.text = String(self.products[self.index!].price)
            self.txtViewDesc.text = self.products[self.index!].description
        }
    }
}
