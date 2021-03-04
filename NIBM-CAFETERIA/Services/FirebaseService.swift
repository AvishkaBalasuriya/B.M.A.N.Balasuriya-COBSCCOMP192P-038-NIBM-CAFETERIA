//
//  FirebaseService.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-02.
//

import UIKit
import FirebaseAuth

class FirebaseService: NSObject {
    func registerUser(emailAddress:String,mobileNumber:String,password:String,result: @escaping (_ authResult: Int?)->Void){
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (response, error) in
            if error != nil {
                if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .emailAlreadyInUse:
                            result(2)
                        default:
                            result(0)
                    }
                }
            }else {
                result(1)
            }
        }
    }
    func loginUser(emailAddress:String,password:String,result: @escaping (_ authResult: Int?)->Void){
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (response, error) in
            if error != nil {
                if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .invalidCredential:
                            result(3)
                        case .emailAlreadyInUse:
                            result(2)
                        default:
                            result(0)
                    }
                }
            }else {
                result(1)
            }
        }
    }
    func forgetPassword(emailAddress:String,result: @escaping (_ authResult: Int?)->Void){
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            if error != nil {
                if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .invalidEmail:
                                result(2)
                        default:
                            result(0)
                    }
                }
            }else {
                result(1)
            }
        }
    }
}
