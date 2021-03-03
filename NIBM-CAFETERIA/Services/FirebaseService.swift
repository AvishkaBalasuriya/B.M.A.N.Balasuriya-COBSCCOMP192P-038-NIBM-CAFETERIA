//
//  FirebaseService.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-02.
//

import UIKit
import FirebaseAuth

class FirebaseService: NSObject {
    func registerUser(emailAddress:String,mobileNumber:String,password:String){
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if (error) != nil {
                print("Error. Unable to register new user")
            }else{
                print("User created")
            }
        }
    }
    func loginUser(emailAddress:String,password:String){
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            if (error) != nil {
                print("Error. Unable to login")
            }else{
                print("User signed in")
            }
        }
    }
    func forgetPassword(emailAddress:String){
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            if (error) != nil {
                print("Error. Unable to send password reset link")
            }else{
                print("Password reset link sent")
            }
        }
    }
}
