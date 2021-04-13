//
//  OrderData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

struct OrderData {
    static var order:Order = Order()
}

func generateOrderId()->String{
    let uuid = NSUUID().uuidString
    return uuid
}
