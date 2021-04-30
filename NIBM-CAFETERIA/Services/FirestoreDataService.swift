//
//  FirestoreDataService.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-04-13.
//

/*
 0 - New
 1 - Preperation
 2 - Ready
 3 - Arriving
 4 - Done
 5 - Cancel
 */

import UIKit
import FirebaseFirestore

class FirestoreDataService: NSObject {
    
    let db = Firestore.firestore()
    
    func addUserToFirestore(user:User,completion: @escaping (Bool)->()){
        db.collection("users").document(user.emailAddress).setData([
            "emailAddress": user.emailAddress,
            "mobileNumber": user.mobileNumber,
            "type":user.type
        ]) { err in
            if err != nil{
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func fetchItems(category:String="Other",completion: @escaping (Bool)->()) {
        var itemList:[Item]=[]
        db.collection("items").whereField("category", isEqualTo: category).whereField("isAvailable", isEqualTo: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(false)
            } else {
                for document in querySnapshot!.documents {
                    let itemId=document.data()["itemId"] as! String
                    let itemName=document.data()["itemName"] as! String
                    let itemDescription=document.data()["itemDescription"] as! String
                    let itemThumbnail=document.data()["itemThumbnail"] as! String
                    let itemPrice=document.data()["itemPrice"] as! Float
                    let itemDiscount=document.data()["itemDiscount"] as! Float
                    let isAvailable=document.data()["isAvailable"] as! Bool
                    let category=document.data()["category"] as! String
                    itemList.append(Item(itemId: itemId, itemName: itemName, itemThumbnail: itemThumbnail, itemDescription: itemDescription, itemPrice: itemPrice,itemDiscount: itemDiscount,isAvailable: isAvailable,category: category))
                }
                populateItemList(items: itemList)
                completion(true)
            }
        }
    }
    
    func fetchUser(user:User,completion: @escaping (Int)->()){
        db.collection("users").document(user.emailAddress).getDocument { (document, error) in
            if let document = document, document.exists {
                let user = User()
                user.emailAddress=document.get("emailAddress") as! String
                user.mobileNumber=document.get("mobileNumber") as! String
                user.type=document.get("type") as! Int
                
                UserDefaults.standard.set(user.mobileNumber, forKey: "mobileNumber")
                UserData.mobileNumber=user.mobileNumber
                completion(200)
            } else {
                completion(404)
            }
        }
    }
    
    func addNewOrder(order:Order,completion: @escaping (Int)->()){
        db.collection("orders").document(order.orderId).setData([
            "orderId":order.orderId,
            "userEmailAddress":order.userEmailAddress,
            "items":order.toAnyObject(),
            "total":order.total,
            "status":order.status,
            "timestamp":order.timestamp,
            "userId":order.userId
        ]){ err in
            if err != nil{
                completion(500)
            } else {
                FirebaseService().addNewOrderStatus(order: order)
                completion(201)
            }
        }
    }
    
    func changeOrderStatus(orderId:String, status:Int, completion: @escaping (Int)->()){
        db.collection("orders").document(orderId).updateData(["status":status]){
            err in
            if let err = err {
                completion(500)
            } else {
                FirebaseService().updateOrderStatus(orderId: orderId, status: status)
                completion(204)
            }
        }
    }
    
    func getAllOrders(completion: @escaping (Any)->()){
        print(UserData.emailAddress)
        db.collection("orders").whereField("userEmailAddress", isEqualTo: UserData.emailAddress).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            var orders:[Order] = []
            for document in querySnapshot!.documents {
                var cart:[CartItem]=[]
                let orderId:String=document.data()["orderId"] as! String
                let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                let items = document.data()["items"] as! [Any]
                for item in items{
                    let itemData = item as! [String:Any]
                    let itemId:String = itemData["itemId"] as! String
                    let itemName:String = itemData["itemName"] as! String
                    let itemQty:Int = itemData["itemQty"] as! Int
                    let itemPrice:Float = itemData["itemPrice"] as! Float
                    let totalPrice:Float = itemData["totalPrice"] as! Float
                    let cartItem = CartItem(itemId: itemId, itemName: itemName, itemQty: itemQty, itemPrice: itemPrice, totalPrice: totalPrice)
                    cart.append(cartItem)
                }
                let total:Float=document.data()["total"] as! Float
                let status:Int=document.data()["status"] as! Int
                let timestamp:Timestamp=document.data()["timestamp"] as! Timestamp
                let userId:String=document.data()["userId"] as! String
                let order = Order(orderId: orderId, userEmailAddress: userEmailAddress, items: cart, total: total, status: status,userId: userId, timestamp: timestamp.dateValue())
                orders.append(order)
            }
            populateOrderList(orders: orders)
            completion(orders)
        }
    }

    func getAllCategories(completion: @escaping (Any)->()){
        db.collection("categories").addSnapshotListener {
            querySnapshot, error in
            if let err = error {
                completion(500)
            }else{
                var categories:[Category]=[]
                for document in querySnapshot!.documents {
                    let categoryId=document.data()["categoryId"] as! String
                    let categoryName=document.data()["categoryName"] as! String
                    categories.append(Category(categoryId: categoryId, categoryName: categoryName))
                }
                populateCategoryList(categories: categories)
                completion(categories)
            }
        }
    }
    
    func getOrdersByStatus(status:Int,completion: @escaping (Any)->()){
        print(UserData.emailAddress)
        var orders:[Order] = []
        db.collection("orders").whereField("userEmailAddress", isEqualTo: UserData.emailAddress).whereField("status", isEqualTo: status).getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                completion(500)
            }else{
                for document in querySnapshot!.documents {
                    var cart:[CartItem]=[]
                    let orderId:String=document.data()["orderId"] as! String
                    let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                    let items = document.data()["items"] as! [Any]
                    for item in items{
                        let itemData = item as! [String:Any]
                        let itemId:String = itemData["itemId"] as! String
                        let itemName:String = itemData["itemName"] as! String
                        let itemQty:Int = itemData["itemQty"] as! Int
                        let itemPrice:Float = itemData["itemPrice"] as! Float
                        let totalPrice:Float = itemData["totalPrice"] as! Float
                        let cartItem = CartItem(itemId: itemId, itemName: itemName, itemQty: itemQty, itemPrice: itemPrice, totalPrice: totalPrice)
                        cart.append(cartItem)
                    }
                    let total:Float=document.data()[
                        "total"] as! Float
                    let status:Int=document.data()["status"] as! Int
                    let timestamp:Timestamp = document.data()["timestamp"] as! Timestamp
                    let userId:String = document.data()["userId"] as! String
                    orders.append(Order(orderId: orderId, userEmailAddress: userEmailAddress, items: cart, total: total, status: status,userId: userId,timestamp:timestamp.dateValue()))
                }
                populateBillOrderList(orders: orders)
                completion(orders)
            }
        }
    }
    
    func getOrdersByDateRange(start:Date,end:Date,status:Int,completion: @escaping (Any)->()){
        var orders:[Order] = []
        db.collection("orders").whereField("timestamp",isGreaterThanOrEqualTo: end).whereField("timestamp", isLessThanOrEqualTo: start).getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                completion(500)
            }else{
                for document in querySnapshot!.documents {
                    if document.data()["userEmailAddress"] as! String == UserData.emailAddress{
                        var cart:[CartItem]=[]
                        let orderId:String=document.data()["orderId"] as! String
                        let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                        let items = document.data()["items"] as! [Any]
                        for item in items{
                            let itemData = item as! [String:Any]
                            let itemId:String = itemData["itemId"] as! String
                            let itemName:String = itemData["itemName"] as! String
                            let itemQty:Int = itemData["itemQty"] as! Int
                            let itemPrice:Float = itemData["itemPrice"] as! Float
                            let totalPrice:Float = itemData["totalPrice"] as! Float
                            let cartItem = CartItem(itemId: itemId, itemName: itemName, itemQty: itemQty, itemPrice: itemPrice, totalPrice: totalPrice)
                            cart.append(cartItem)
                        }
                        let total:Float=document.data()[
                            "total"] as! Float
                        let status:Int=document.data()["status"] as! Int
                        let timestamp:Timestamp = document.data()["timestamp"] as! Timestamp
                        let userId:String = document.data()["userId"] as! String
                        orders.append(Order(orderId: orderId, userEmailAddress: userEmailAddress, items: cart, total: total, status: status,userId: userId,timestamp:timestamp.dateValue()))
                    }
                }
                populateBillOrderList(orders: orders)
                completion(orders)
            }
        }
    }
}
