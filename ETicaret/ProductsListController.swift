//
//  ProductsListController.swift
//  ETicaret
//
//  Created by melisa öztürk on 30.09.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import UIKit

class ProductsListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ViewModel()
    var products = [Product]()
    let popup = Popup()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        
        self.viewModel.viewModelDelegate = self
        UIUtil.shared().showLoading(view: (self.view)!)
        self.viewModel.getProduct()
    }
    
    private func registerTableView() {
        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    @IBAction func actionAddProduct(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as? Popup {
//            self.popup.popupDelegate = self
            vc.popupDelegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
}

extension ProductsListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.lblTitle.text = products[indexPath.row].title
        cell.lblPrice.text = String(products[indexPath.row].price)
        
        return cell
    }    
}

extension ProductsListController: ViewModelDelegate {
    func updateTableData(products: [Product]) {
        self.products = products
        UIUtil.shared().removeLoading(view: self.view)
        self.tableView.reloadData()
    }
}

extension ProductsListController: PopupDelegate {
//    func closePopUp() {
//        self.popup.removeFromParent()
////        self.tableView.isHidden = false
//    }
    
    func saveData() {
//        TODO: save new data
        self.navigationController?.popViewController(animated: true)
    }
}
