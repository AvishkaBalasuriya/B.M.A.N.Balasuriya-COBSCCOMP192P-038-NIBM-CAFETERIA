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
    
    func registerUser(user:User,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.mobileNumber != "" && user.password != ""){
            Auth.auth().createUser(withEmail: user.emailAddress, password: user.password) { (response, error) in
                if error != nil {
                    print(error)
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
    
}
