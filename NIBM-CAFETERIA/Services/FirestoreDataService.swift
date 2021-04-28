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
        db.collection("items").whereField("category", isEqualTo: category).getDocuments() { (querySnapshot, err) in
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
                
                UserData.emailAddress=user.emailAddress
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
            "timestamp":order.timestamp
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
        db.collection("orders").whereField("userEmailAddress", isEqualTo: UserData.emailAddress).addSnapshotListener { querySnapshot, error in
            var orders:[Order] = []
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            for document in querySnapshot!.documents {
                let orderId:String=document.data()["orderId"] as! String
                let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                var items:[CartItem]=[]
                let total:Float=document.data()["total"] as! Float
                let status:Int=document.data()["status"] as! Int
                let timestamp:Timestamp=document.data()["timestamp"] as! Timestamp
                let order = Order(orderId: orderId, userEmailAddress: userEmailAddress, items: items, total: total, status: status,timestamp: timestamp.dateValue())
                orders.append(order)
            }
            populateOrderList(orders: orders)
            completion(orders)
        }
    }

}
