//
//  UserModel.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-05.
//

import UIKit

class User: NSObject {
    var emailAddress:String
    var mobileNumber:String
    var password:String
    var type:Int
    
    init(emailAddress:String="",mobileNumber:String="",password:String="",type:Int=0) {
        self.emailAddress=emailAddress
        self.mobileNumber=mobileNumber
        self.password=password
        self.type=type
    }
    
    override init() {
        self.emailAddress=""
        self.mobileNumber=""
        self.password=""
        self.type=0
    }
}
