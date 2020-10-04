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
//TODO: id ler yanlış yazılıyor düzenle
//TODO: Silme, düzenleme gibi fonksiyonları ekleyebilirsin
//TODO: güne göre sıralıyor yıl yap
//TODO: popup ta keyboard done butonu yap
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
        ref.child("products").observe(.value, with: { (snapshot) in
            self.products.removeAll()
            let values = snapshot.value as? [String: AnyObject]
            if values == nil {
                self.setProduct(id: snapshot.key, category: "Elektronik", title: "Bilgisayar-20.11.2018", price: 100.000, description: "abc", date: "20.11.2018")
                self.setProduct(id: snapshot.key, category: "BeyazEşya", title: "BuzDolabı-21.11.2018", price: 100.000, description: "abc", date: "21.11.2018")
                self.setProduct(id: snapshot.key, category: "Elektronik", title: "Tv-22.11.2018", price: 100.000, description: "abc", date: "22.11.2018")
                self.setProduct(id: snapshot.key, category: "Kırtasiye", title: "Kalem-23.11.2018", price: 100.000, description: "abc", date: "23.11.2018")
                self.setProduct(id: snapshot.key, category: "BeyazEşya", title: "Klima-10.07.1996", price: 100.000, description: "abc", date: "10.07.1996")
               
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
        self.sortedProduct.removeAll()
        ref.child("products").queryOrdered(byChild: "date").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
           let values = snapshot.value as? [String: AnyObject]
            for (_, value) in values!.enumerated() {
                let id = value.value["id"] as? String
                let title = value.value["title"] as? String
                let category = value.value["category"] as? String
                let price = value.value["price"] as? Double
                let description = value.value["description"] as? String
                let date = value.value["date"] as? String
                
                self.sortedProduct.append(Product(id: id, title: title, category: category, price: price, description: description, date: date))
                self.viewModelDelegate?.updateTableData(products: self.sortedProduct)
            }
        })
    }
    
    private func createModel(values: [String: AnyObject]) {
//        self.products.removeAll()
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
    
    func deleteData() {
        //        ref.child("products")
    }
}
