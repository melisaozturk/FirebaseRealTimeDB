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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        
        self.viewModel.viewModelDelegate = self
        self.viewModel.getProduct()
    }
    
    private func registerTableView() {
        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        self.tableView.reloadData()
    }
}
