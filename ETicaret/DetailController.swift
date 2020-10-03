//
//  DetailController.swift
//  ETicaret
//
//  Created by melisa öztürk on 3.10.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtViewDesc: UITextView!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
    }
    
    private func setData() {
        self.lblTitle.text = self.product.title
        self.lblCategory.text = self.product.category
        self.lblPrice.text = String(self.product.price)
        self.lblDate.text = self.product.date
        self.txtViewDesc.text = self.product.description
    }

}
