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
    var numberInCart: Double? = 0
    
    func existsInCart() -> Bool? {
        do {
            let recipes = try CartPersistenceManager.manager.getCart()
            
            if recipes.contains(where: {$0.id == self.id}) {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return nil
        }
    }
}
