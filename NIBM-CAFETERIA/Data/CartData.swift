//
//  CartData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

struct CartData {
    static var cartItemList:[CartItem] = []
}

func addNewItem(item:CartItem){
    CartData.cartItemList.append(item)
}

func removeCart(){
    CartData.cartItemList=[]
}
