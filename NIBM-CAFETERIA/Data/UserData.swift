//
//  UserData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-05.
//

import Foundation

struct UserData {
    static var emailAddress:String = ""
    static var mobileNumber:String = ""
    static var uuid:String = ""
}

func setUserData(user:User){
    UserData.emailAddress=user.emailAddress
    UserData.mobileNumber=user.mobileNumber
    UserData.uuid=user.uuid
}
