//
//  CartData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

struct CartData {
    static var cartList:[CartModel] = []
}

func addNewItem(item:CartModel){
    CartData.cartList.append(item)
}

func removeCart(){
    CartData.cartList=[]
}
