//
//  FirebaseService.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-02.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class FirebaseService: NSObject {
    
    let firestoreDataService = FirestoreDataService()
    let notificationService = NotificationService()
    
    func registerUser(user:User,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.mobileNumber != "" && user.password != ""){
            Auth.auth().createUser(withEmail: user.emailAddress, password: user.password) { (response, error) in
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .emailAlreadyInUse:
                                result(409)
                            default:
                                result(500)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    self.firestoreDataService.addUserToFirestore(user: user){
                        completion in
                        if completion{
                            user.uuid=(response?.user.uid)!
                            setUserData(user: user)
                            UserDefaults.standard.set(true, forKey: "isLogged")
                            result(201)
                        }else{
                            result(500)
                        }
                    }
                }
            }
        }else{
            result(400)
        }
    }
    
    func loginUser(user:User,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.password != ""){
            Auth.auth().signIn(withEmail: user.emailAddress, password: user.password) { (response, error) in
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .invalidCredential:
                                result(401)
                            case .wrongPassword:
                                result(401)
                            case .invalidEmail:
                                result(401)
                            default:
                                result(500)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    UserDefaults.standard.set(true, forKey: "isLogged")
                    UserData.uuid=(response?.user.uid)!
                    result(200)
                }
            }
        }else{
            result(400)
        }
    }
    
    func forgetPassword(emailAddress:String,result: @escaping (_ authResult: Int?)->Void){
        if (emailAddress != ""){
            Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .invalidEmail:
                                    result(401)
                            default:
                                result(500)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    UserDefaults.standard.set(false, forKey: "isLogged")
                    result(200)
                }
            }
        }else{
            result(400)
        }
    }
    
    func listenToResturentLiveLocation(){
        let ref = Database.database().reference()
        ref.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let latitude =  postDict["RESTURENTLOCATION"]?["LATITUDE"] as! Double
            let longitude = postDict["RESTURENTLOCATION"]?["LONGITUDE"] as! Double
            RESTURENTLOCATION.latitude=latitude
            RESTURENTLOCATION.longitude=longitude
        })
    }
    
    func listenToOrderStatus(){
        let ref = Database.database().reference().child("orders").child(UserData.uuid)
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if !snapshot.exists() {
                    return
            }
            var data = snapshot.value as! [String: Any]
            for (key,value) in data{
                let statusData = value as! [String:Any]
                var orderStatusData:StatusDataModel=StatusDataModel()
                orderStatusData.orderId=statusData["orderId"] as! String
                orderStatusData.status=statusData["status"] as! Int
                orderStatusData.isRecieved=statusData["isRecieved"] as! Bool
                if orderStatusData.status != 0 && orderStatusData.status != 3{
                    if orderStatusData.isRecieved == false{
                        self.notificationService.pushNotification(orderId: orderStatusData.orderId, orderStatus: orderStatusData.status){
                            result in
                            if result == true{
                                self.markOrderAsRecieved(orderStatusData: orderStatusData,key: key)
                            }
                        }
                    }
                }
            }
        })
    }
    
    func addNewOrderStatus(order:Order){
        var statusData:StatusDataModel=StatusDataModel()
        statusData.status=order.status
        statusData.isRecieved=false
        statusData.orderId=order.orderId
        var orderData = statusData.asDictionary
        let ref = Database.database().reference().child("orders").child(UserData.uuid).child(order.orderId)
        ref.setValue(orderData)
    }
    
    func updateOrderStatus(orderId:String,status:Int){
        let ref = Database.database().reference().child("orders").child(UserData.uuid).child(orderId)
        ref.updateChildValues(["status":status,"isRecieved":false])
    }
    
    func markOrderAsRecieved(orderStatusData:StatusDataModel,key:String){
        orderStatusData.isRecieved=true
        print("Updating order status")
        let ref = Database.database().reference().child("orders").child(UserData.uuid).child(key).setValue(orderStatusData.asDictionary)
    }
    
}
