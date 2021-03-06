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
    @IBOutlet weak var btnSort: UIButton!
    
    let viewModel = ViewModel()
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        
        self.viewModel.viewModelDelegate = self
        Util.shared().showLoading(viewController: self)
        self.viewModel.getProduct()
        
        self.btnSort.isHidden = true
    }
    
    private func registerTableView() {
        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    @IBAction func actionAddProduct(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as? Popup {
            vc.popupDelegate = self
            self.addChild(vc)
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    @IBAction func actionSort(_ sender: Any) {
        Util.shared().showLoading(viewController: self)
//        self.viewModel.sortData()
    }
}

extension ProductsListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.selectionStyle = .none
        cell.lblTitle.text = products[indexPath.row].title ?? ""
        cell.lblPrice.text = String(products[indexPath.row].price) ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as? DetailController {
            vc.product = self.products[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction(style: .default, title: "Delete", handler: {
            (action, indexPath) in
            self.viewModel.deleteData(selectedIndex: indexPath.row)
        })
        action1.backgroundColor = UIColor.lightGray
        let action2 = UITableViewRowAction(style: .default, title: "Update", handler: {
            (action, indexPath) in
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as? Popup {
                vc.popupDelegate = self
                vc.index = indexPath.row
                vc.products = self.products
                self.addChild(vc)
                vc.view.frame = self.view.frame
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
            }        })
        return [action1, action2]
    }
}

extension ProductsListController: ViewModelDelegate {
    func updateTableData(products: [Product]) {
        self.products = products
        Util.shared().removeLoading(viewController: self)
        self.tableView.reloadData()        
    }
}

extension ProductsListController: PopupDelegate {
    func saveData(viewController: UIViewController, product: Product, index: Int?) {
        if index == nil {
            self.viewModel.setProduct(id: "", category: product.category ?? "", title: product.title ?? "", price: product.price ?? 0.0, description: product.description ?? "", date: Util.shared().getDate())
            Util.shared().removeFromView(viewController: viewController)
            self.products.append(product)
            self.tableView.reloadData()
        } else {
            let updatedProduct = Product(id: "", title: product.title ?? "", category: product.category ?? "", price: product.price ?? 0.0, description: product.description ?? "", date: Util.shared().getDate())
            self.viewModel.updateData(selectedIndex: index!, updatedProduct: updatedProduct)
            Util.shared().removeFromView(viewController: viewController)
            self.tableView.reloadData()
        }
    }
}
