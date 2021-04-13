//
//  OrderData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

struct OrderData {
    static let order:Order = Order()
}

func generateOrderId()->String{
    let uuid = NSUUID().uuidString
    return uuid
}

func generateOrderTotal()->Float{
    var total:Float = 0.0
    for item in OrderData.order.items{
        total+=item.itemPrice
    }
    return total
}
