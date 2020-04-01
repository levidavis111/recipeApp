//
//  Recipe.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import Foundation

struct RecipeWrapper: Codable {
    let results: [Recipe]
}

struct Recipe: Codable {
    let id: Int
    let image: String
    let imageUrls: [String]
    let readyInMinutes: Int
    let servings: Int
    let title: String
    let numberInCart = 0
}
//https://api.spoonacular.com/recipes/search?query=cheese&number=2&apiKey=

/**
 {
     "offset": 0,
     "number": 2,
     "results": [
         {
             "id": 633508,
             "image": "Baked-Cheese-Manicotti-633508.jpg",
             "imageUrls": [
                 "Baked-Cheese-Manicotti-633508.jpg"
             ],
             "readyInMinutes": 45,
             "servings": 6,
             "title": "Baked Cheese Manicotti"
         },
         {
             "id": 634873,
             "image": "Best-Baked-Macaroni-and-Cheese-634873.jpg",
             "imageUrls": [
                 "Best-Baked-Macaroni-and-Cheese-634873.jpg"
             ],
             "readyInMinutes": 45,
             "servings": 12,
             "title": "Best Baked Macaroni and Cheese"
         }
     ],
     "totalResults": 719
 }
 */
