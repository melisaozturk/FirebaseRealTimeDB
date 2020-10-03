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
//TODO: değişiklikleri gözle bir veri veritabanında silinirse table'ı update et
class ViewModel: NSObject {
    
    private var ref: DatabaseReference!
    var viewModelDelegate: ViewModelDelegate?
    var products = [Product]()
    var sortedProduct = [Product]()
    
    override init() {
        super.init()
        self.ref = Database.database().reference()
    }
    
//    Veritabanını oluşturuyoruz.  Kullanıcının girdiği veriler de yine buradan ekleniyor
    func setProduct(id: String, category: String, title: String, price: Double, description: String, date: String) { // TODO: close ekle success ise uyarı gösterip ekranı kapatsın
        ref.child("products").childByAutoId().setValue(["title" : title, "category": category, "price": price, "id": ref.childByAutoId().key!
            , "description": description, "date": date])
    }
    
//    Listeleme vb işlemler için veritabanından verileri alıyoruz.
    func getProduct() {
        ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String: AnyObject]
            
            if values == nil {
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Elektronik", title: "Bilgisayar", price: 100.000, description: "abc", date: Util.shared().getDate())
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Beyaz Eşya", title: "Buz Dolabı", price: 100.000, description: "abc", date: Util.shared().getDate())
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Elektronik", title: "Tv", price: 100.000, description: "abc", date: Util.shared().getDate())
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Elektronik", title: "Bilgisayar", price: 100.000, description: "abc", date: Util.shared().getDate())
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Elektronik", title: "Bilgisayar", price: 100.000, description: "abc", date: Util.shared().getDate())
                self.ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
                    let values = snapshot.value as? [String: AnyObject]
                    self.createModel(values: values!)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                self.createModel(values: values!)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func sortData() {
        ref.child("products").queryOrdered(byChild: "date").observe(.childAdded, with: { (snapshot) -> Void in
            let value = snapshot.value as? [String: AnyObject]
            
            
//                let itemRef = shoppingListsRef.child(item)
//                itemRef.observe(.value, with: { (snapshot) in
//                    if let value = snapshot.value as? [String: Any] {
//                        let name = value["name"] as? String ?? ""
//                        let owner = value["owner"] as? String ?? ""
//                        print(name, owner)
//                    }
//                })
            
            
            
//            for (_, item) in values!.enumerated() {
            let id = value!["id"] as? String
            let title = value!["title"] as? String
            let category = value!["category"] as? String
            let price = value!["price"] as? Double
            let description = value!["description"] as? String
            let date = value!["date"] as? String
            
                let sortedProduct = Product(id: id, title: title, category: category, price: price, description: description, date: date)
                self.sortedProduct.append(sortedProduct)
//            }
                        
            self.viewModelDelegate?.updateTableData(products: self.sortedProduct)
            //        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.posts.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
    }
    
    private func createModel(values: [String: AnyObject]) {
        for (_, value) in values.enumerated() {
            let id = value.value["id"] as? String
            let title = value.value["title"] as? String
            let category = value.value["category"] as? String
            let price = value.value["price"] as? Double
            let description = value.value["description"] as? String
            let date = value.value["date"] as? String
            
            self.products.append(Product(id: id, title: title, category: category, price: price, description: description, date: date))
            
        }
        self.viewModelDelegate!.updateTableData(products: self.products)
    }
}
