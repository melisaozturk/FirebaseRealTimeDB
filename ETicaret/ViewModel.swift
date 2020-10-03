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
//TODO: değişiklikleri gözle bir veri veritabanında silinirse table'ı update et. NotificationCenter kullan.
//TODO: Eklenme tarihi ekle ve ona göre sırala
class ViewModel: NSObject {
    
    enum CalculationType {
        case add
        case sort
    }
    
    private var ref: DatabaseReference!
    var products = [Product]()
    var viewModelDelegate: ViewModelDelegate?
    var calculationType: CalculationType!
    
    override init() {
        super.init()
        self.ref = Database.database().reference()
    }
    
    //    Veritabanını oluşturuyoruz.  Kullanıcının girdiği veriler de yine buradan ekleniyor
    func setProduct(id: String?, category: String, title: String, price: Double, description: String, date: String) { // TODO: close ekle success ise uyarı gösterip ekranı kapatsın
        ref.child("products").childByAutoId().setValue(["title" : title, "category": category, "price": price, "id": ref.childByAutoId().key!
            , "description": description, "date": date])
    }
    
    //    Listeleme vb işlemler için veritabanından verileri alıyoruz.
    func getProduct() {
        ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? [String: AnyObject]
            
            if values == nil {
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Elektronik", title: "Bilgisayar", price: 100.000, description: "abc", date: self.getDate())
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Beyaz Eşya", title: "Buz Dolabı", price: 100.000, description: "abc", date: self.getDate())
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Elektronik", title: "Tv", price: 100.000, description: "abc", date: self.getDate())
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Elektronik", title: "Bilgisayar", price: 100.000, description: "abc", date: self.getDate())
                self.setProduct(id: self.ref.childByAutoId().key!, category: "Elektronik", title: "Bilgisayar", price: 100.000, description: "abc", date: self.getDate())
                self.ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
                    let values = snapshot.value as? [String: AnyObject]
                    self.calculationType = .add
                    self.products = self.createModel(values: values!, createdProducts: &self.products)
                    self.viewModelDelegate!.updateTableData(products: self.products)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                self.calculationType = .add
                self.products = self.createModel(values: values!, createdProducts: &self.products)
                self.viewModelDelegate!.updateTableData(products: self.products)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func sortData() {
        _ = ref.child("products").queryOrdered(byChild: "date").observe(.childAdded, with: { (snapshot) -> Void in
            let values = snapshot.value as? [String: AnyObject]
            var sortedProducts = [Product]()
            self.calculationType = .sort
            sortedProducts = self.createModel(values: values!, createdProducts: &sortedProducts)
            self.viewModelDelegate!.updateTableData(products: sortedProducts)
            //        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.posts.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
    }
    
    private func createModel(values: [String: AnyObject], createdProducts: inout [Product]) -> [Product] {
        
        switch self.calculationType {
        case .add:
            for (_, value) in values.enumerated() {
                let id = value.value["id"] as? String
                let title = value.value["title"] as? String
                let category = value.value["category"] as? String
                let price = value.value["price"] as? Double
                let description = value.value["description"] as? String
                let date = value.value["date"] as? String
                
                createdProducts.append(Product(id: id, title: title, category: category, price: price, description: description, date: date))
            }
            break
        case .sort:
            var p: Product!
            for (index, item) in values {
                p = Product(id: values[index].value["id"] as? String, title: values[index].value["title"] as? String, category: values[index].value["category"] as? String, price: values[index].value["price"] as? Double, description: values[index].value["description"] as? String, date: values[index].value["date"] as? String)
            }
            createdProducts.append(p)
            break
        default:
            break
        }
        return createdProducts
    }
    
    private func getDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
