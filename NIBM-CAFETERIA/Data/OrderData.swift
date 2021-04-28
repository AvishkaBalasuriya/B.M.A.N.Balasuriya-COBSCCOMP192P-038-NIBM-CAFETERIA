//
//  OrderData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

struct OrderData {
    static var orderList:[String:Order] = [String: Order]()
}

func populateOrderList(orders:[Order]){
    var orderList:[String:Order]=[String: Order]()
    for order in orders{
        orderList[order.orderId]=order
    }
    OrderData.orderList=orderList
}

func generateOrderId()->String{
    let uuid = NSUUID().uuidString.replacingOccurrences(of:
        "-", with: "")
    return uuid
}
