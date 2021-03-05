//
//  FoodData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

var firebaseFoodData=FirebaseService()

struct FoodData {
    static var foodList:[ItemModel] = []
}

func populateFoodList(foods:[ItemModel]){
    FoodData.foodList=foods
}
