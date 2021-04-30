//
//  CategoryData.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-04-30.
//

import Foundation

struct CategoryData {
    static var categoryList:[Category] = []
}

func populateCategoryList(categories:[Category]){
    CategoryData.categoryList=categories
}
