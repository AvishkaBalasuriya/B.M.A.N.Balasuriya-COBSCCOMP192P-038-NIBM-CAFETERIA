//
//  CartModel.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-03.
//

import UIKit

class CartModel: NSObject {
    var foodId:Int = 0
    var foodName:String
    var foodQty:Int
    var totalPrice:Float
    var foodPrice:Float
    
    init(foodId:Int,foodName:String,foodQty:Int,totalPrice:Float,foodPrice:Float) {
        self.foodId=foodId
        self.foodName=foodName
        self.foodQty=foodQty
        self.foodPrice=foodPrice
        self.totalPrice=totalPrice
    }
    
}
