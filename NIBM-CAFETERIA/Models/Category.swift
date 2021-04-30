//
//  Category.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-04-30.
//

import UIKit

class Category: NSObject {
    var categoryId:String
    var categoryName:String
    
    init(categoryId:String,categoryName:String) {
        self.categoryId=categoryId
        self.categoryName=categoryName
    }
}
