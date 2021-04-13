//
//  FirestoreDataService.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-04-13.
//

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
    
    func fetchItems(completion: @escaping (Bool)->()) {
        var itemList:[Item]=[]
        db.collection("items").getDocuments() { (querySnapshot, err) in
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
                    itemList.append(Item(itemId: itemId, itemName: itemName, itemThumbnail: itemThumbnail, itemDescription: itemDescription, itemPrice: itemPrice,itemDiscount: itemDiscount,isAvailable: isAvailable))
                }
                populateItemList(items: itemList)
                completion(true)
            }
        }
    }
    
    func fetchUser(user:User,completion: @escaping (Any)->()){
        db.collection("users").document(user.emailAddress).getDocument { (document, error) in
            if let document = document, document.exists {
                let user = User()
                user.emailAddress=document.get("emailAddress") as! String
                user.mobileNumber=document.get("mobileNumber") as! String
                user.type=document.get("type") as! Int
                completion(user)
            } else {
                completion(404)
            }
        }
    }

}
