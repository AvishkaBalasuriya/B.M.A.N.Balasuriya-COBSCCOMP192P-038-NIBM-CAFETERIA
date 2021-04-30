//
//  BillOrderData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-04-30.
//

import Foundation

struct BillOrderData {
    static var billOrderList:[Order] = []
}

func populateBillOrderList(orders:[Order]){
    BillOrderData.billOrderList=orders
}
