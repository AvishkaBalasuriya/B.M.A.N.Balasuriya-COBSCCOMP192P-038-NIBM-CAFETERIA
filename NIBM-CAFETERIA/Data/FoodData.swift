//
//  FoodData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import Foundation

var firebaseFoodData=FirebaseService()

struct FoodData {
    static var foodList:[ItemModel] = [ItemModel(foodId: 1, foodName:"mew", foodDescription: "dededef dwdwd dwdw", foodPrice: 200.00, foodPhoto: "Food", foodDiscount: 10.0)]
}

func addNewFood(food:ItemModel){
    if FoodData.foodList.count>0{
        for food_data in FoodData.foodList{
            if(food.foodId == food_data.foodId){
                print("Already fetched")
            }else{
                FoodData.foodList.append(food)
            }
        }
    }else{
        FoodData.foodList.append(food)
    }
}

func fetchFoodData(){
    firebaseFoodData.fetchFoodsData()
}
