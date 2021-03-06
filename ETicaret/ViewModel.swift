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
    var viewModelDelegate: ViewModelDelegate?
    private var products = [Product]()
    private var sortedProduct = [Product]()
    private var values: [String: AnyObject]?
    private var key: String?
    
    override init() {
        super.init()
        self.ref = Database.database().reference()
    }
    
    func setProduct(id: String, category: String, title: String, price: Double, description: String, date: String) {
        ref.child("products").childByAutoId().setValue(["title" : title, "category": category, "price": price, "id": ref.childByAutoId().key!
            , "description": description, "date": date])
    }
    
    func getProduct() {
        ref.child("products").observe(.value, with: { (snapshot) in
            self.products.removeAll()
            let values = snapshot.value as? [String: AnyObject]
            self.values = values
            if values == nil {
                Util.shared().showAlert(message: "Listenizde ürün bulunmamaktadır.")
                self.viewModelDelegate?.updateTableData(products: self.products)

//                self.setProduct(id: snapshot.key, category: "Elektronik", title: "Bilgisayar", price: 100.000, description: "Bilgisayar", date: "20.11.2018")
//                self.setProduct(id: snapshot.key, category: "Beyazeşya", title: "Buzdolabı", price: 100.000, description: "BuzDolabı", date: "21.11.2018")
//                self.setProduct(id: snapshot.key, category: "Elektronik", title: "Tv", price: 100.000, description: "Tv", date: "22.11.2018")
//                self.setProduct(id: snapshot.key, category: "Kırtasiye", title: "Kalem", price: 100.000, description: "Kalem", date: "23.11.2018")
//                self.setProduct(id: snapshot.key, category: "Beyazeşya", title: "Klima", price: 100.000, description: "Klima", date: "10.07.1996")

//                self.ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
//                    let values = snapshot.value as? [String: AnyObject]
//                    self.createModel(values: values!)
//
//                }) { (error) in
//                    print(error.localizedDescription)
//                }
            } else {
                self.createModel(values: values!)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
//    func sortData() {
//        self.sortedProduct.removeAll()
//        ref.child("products").queryOrdered(byChild: "category").observe(.childAdded, with: { (snapshot) -> Void in
//            let value = snapshot.value as? [String: AnyObject]
//            let id = value!["id"] as? String
//            let title = value!["title"] as? String
//            let category = value!["category"] as? String
//            let price = value!["price"] as? Double
//            let description = value!["description"] as? String
//            let date = value!["date"] as? String
//
//            let sortedProduct = Product(id: id, title: title, category: category, price: price, description: description, date: date)
//            self.sortedProduct.append(sortedProduct)
//
//            self.viewModelDelegate?.updateTableData(products: self.sortedProduct)
//        })
//    }
    
    func deleteData(selectedIndex: Int) {
        self.getKey(selectedIndex: selectedIndex)
        ref.child("products").child(key!).removeValue(completionBlock: { error, reference in
            if error != nil {
                #if DEBUG
                print("delete failed")
                #endif
            } else {
                self.getProduct()
            }
        })
    }
    
    func updateData(selectedIndex: Int, updatedProduct: Product) {
        self.getKey(selectedIndex: selectedIndex)
        ref.child("products").child(key!).updateChildValues(["id": ref.childByAutoId().key!, "category": updatedProduct.category!, "title": updatedProduct.title!, "description": updatedProduct.description!, "price": updatedProduct.price!], withCompletionBlock: { _,_ in
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
            self.viewModelDelegate!.updateTableData(products: self.products)
        }
    }
    
    private func getKey(selectedIndex: Int) {
        for (index, value) in self.values!.enumerated() {
            if index == selectedIndex {
                self.key = value.key
            }
        }
    }
}
