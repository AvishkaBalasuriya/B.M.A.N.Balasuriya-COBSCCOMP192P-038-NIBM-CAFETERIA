//
//  FoodData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

struct FoodData {
    static var foodList:[ItemModel] = []
}

func fetchFoodData(){
    FoodData.foodList=[ItemModel(foodId: 1, foodName: "Noodles", foodDescription: "This is a chineese spicy noodles", foodPrice: 350.0, foodPhoto: "Food", foodDiscount: 10.0),ItemModel(foodId: 2, foodName: "Fried Rice", foodDescription: "This is a classic mongolian rice", foodPrice: 450.0, foodPhoto: "Food", foodDiscount: 10.0)]
}
