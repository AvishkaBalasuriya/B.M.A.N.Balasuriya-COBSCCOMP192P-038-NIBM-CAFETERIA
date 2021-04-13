//
//  FoodData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

var firebaseFoodData=FirebaseService()

struct ItemData {
    static var itemList:[Item] = []
}

func populateItemList(items:[Item]){
    ItemData.itemList=items
}
