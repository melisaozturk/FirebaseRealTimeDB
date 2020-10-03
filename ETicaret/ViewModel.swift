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
    func updateTableData(products: [Product])
}

class ViewModel: NSObject {
    
    private var ref: DatabaseReference!
    var products = [Product]()
    var viewModelDelegate: ViewModelDelegate?
    
    override init() {
        super.init()
        self.ref = Database.database().reference()
    }
    
//    Veritabanını oluşturuyoruz.  Kullanıcının girdiği veriler de yine buradan ekleniyor
    func setProduct(id: Int, category: String, title: String, price: Double, description: String) { // TODO: close ekle success ise uyarı gösterip ekranı kapatsın
        ref.child("products").childByAutoId().setValue(["title" : title, "category": category, "price": price, "id": id, "description": description])
    }
    
//    Listeleme vb işlemler için veritabanından verileri alıyoruz.
    func getProduct() {
        ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String: AnyObject]
            
            if values == nil {
                self.setProduct(id: 1, category: "Elektronik", title: "Bilgisayar", price: 10000.0, description: "abc")
                self.setProduct(id: 2, category: "Beyaz Eşya", title: "Buz Dolabı", price: 10000.0, description: "abc")
                self.setProduct(id: 3, category: "Elektronik", title: "Tv", price: 10000.0, description: "abc")
                self.setProduct(id: 4, category: "Elektronik", title: "Bilgisayar", price: 10000.0, description: "abc")
                self.setProduct(id: 5, category: "Elektronik", title: "Bilgisayar", price: 10000.0, description: "abc")
                self.ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
                let values = snapshot.value as? [String: AnyObject]

                  for (_, value) in values!.enumerated() {
                      let id = value.value["id"] as? Int
                      let title = value.value["title"] as? String
                      let category = value.value["category"] as? String
                      let price = value.value["price"] as? Double
                      let description = value.value["description"] as? String
                      
                      self.products.append(Product(id: id, title: title, category: category, price: price, description: description))
                      
                  }
               
                  self.viewModelDelegate!.updateTableData(products: self.products)
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                
                for (_, value) in values!.enumerated() {
                    let id = value.value["id"] as? Int
                    let title = value.value["title"] as? String
                    let category = value.value["category"] as? String
                    let price = value.value["price"] as? Double
                    let description = value.value["description"] as? String
                    
                    self.products.append(Product(id: id, title: title, category: category, price: price, description: description))
                    
                }
                self.viewModelDelegate!.updateTableData(products: self.products)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func sortData() {
        
    }
}
