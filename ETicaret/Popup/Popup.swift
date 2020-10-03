//
//  Popup.swift
//  ETicaret
//
//  Created by melisa öztürk on 3.10.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import UIKit

protocol PopupDelegate {
//    func closePopUp()
    func saveData()
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
    }

    @IBAction func actionClose(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let _ = self else { return }
            self!.view.alpha = 0.0
        }) { (isClose: Bool) in
            if isClose {
                self.view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.popupDelegate?.saveData()
    }
}
