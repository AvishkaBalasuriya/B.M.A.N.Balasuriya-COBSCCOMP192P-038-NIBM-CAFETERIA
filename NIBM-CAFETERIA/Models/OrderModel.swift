//
//  OrderModel.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import UIKit

class Order: NSObject {
    var orderId:String
    var userEmailAddress:String
    var items:[CartItem]
    var total:Float
    var status:Int
    
    init(orderId:String,userEmailAddress:String,items:[CartItem],total:Float,status:Int) {
        self.orderId=orderId
        self.userEmailAddress=userEmailAddress
        self.items=items
        self.total=total
        self.status=status
    }
    
    override init(){
        self.orderId=""
        self.userEmailAddress=""
        self.items=[]
        self.total=0.0
        self.status=0
    }
    
    func toAnyObject() -> Any {
        var cartItemList:[Any]=[]
        for item in self.items{
            cartItemList.append([
                "itemId":item.itemId,
                "itemName":item.itemName,
                "itemQty": item.itemQty,
                "itemPrice":item.itemPrice,
                "totalPrice":item.totalPrice
            ])
        }
        return cartItemList
    }
}
