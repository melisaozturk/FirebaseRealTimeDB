//
//  ViewModel.swift
//  ETicaret
//
//  Created by melisa öztürk on 29.09.2020.
//  Copyright © 2020 melisa öztürk. All rights reserved.
//

import Foundation
import Firebase

protocol ViewModelDelegate {
    func updateTableData(product: Product)
}

class ViewModel: NSObject {
    
    private var ref: DatabaseReference!
    var product = Product()
    var viewModelDelegate: ViewModelDelegate?
    
    override init() {
        super.init()
        self.ref = Database.database().reference()
        
        self.setProduct(id: 1, category: "Elektronik", title: "Bilgisayar", price: 10000.0, description: "abc")
        self.setProduct(id: 2, category: "Elektronik", title: "Bilgisayar", price: 10000.0, description: "abc")
        self.setProduct(id: 3, category: "Elektronik", title: "Bilgisayar", price: 10000.0, description: "abc")
        self.setProduct(id: 4, category: "Elektronik", title: "Bilgisayar", price: 10000.0, description: "abc")
        self.setProduct(id: 5, category: "Elektronik", title: "Bilgisayar", price: 10000.0, description: "abc")
    }
    
//    Veritabanını oluşturuyoruz.  Kullanıcının girdiği veriler de yine buradan ekleniyor
    func setProduct(id: Int, category: String, title: String, price: Double, description: String) {
        ref.child("products").childByAutoId().setValue(["title" : title, "category": category, "price": price, "id": id, "description": description])

    }
    
//    Listeleme vb işlemler için veritabanından verileri alıyoruz.
    func getProduct() {
        ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let id = value?["id"] as? Int ?? 0
            let title = value?["title"] as? String ?? ""
            let category = value?["category"] as? String ?? ""
            let price = value?["price"] as? Double ?? 0.0
            let description = value?["description"] as? String ?? ""
            
            self.product = Product(id: id, title: title, category: category, price: price, description: description)
            self.viewModelDelegate!.updateTableData(product: self.product)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func sortData() {
        
    }
    
    func deleteData() {
        
    }
}
