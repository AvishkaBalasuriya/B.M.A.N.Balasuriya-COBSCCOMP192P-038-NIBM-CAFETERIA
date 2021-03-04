//
//  OrderModel.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import UIKit

class OrderModel: NSObject {
    var orderId:Int = 0
    var orderStatus:String="Pending"
    
    init(orderId:Int,orderStatus:String) {
        self.orderId=orderId
        self.orderStatus=orderStatus
    }
}
