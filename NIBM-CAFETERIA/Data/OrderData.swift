//
//  OrderData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

struct OrderData {
    static var orderId:Int = 1
    static var orderList:[OrderModel] = []{
        didSet{
            orderId+=1
        }
    }
}

func addNewOrder(order:OrderModel){
    OrderData.orderList.append(order)
}
