//
//  CartPersistenceManager.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import Foundation

struct CartPersistenceManager {

    static let manager = CartPersistenceManager()
    private let persistenceHelper = PersistenceHelper<Recipe>(fileName: "cart.plist")
    
    func saveRecipeToCart(recipe: Recipe) throws {
        try persistenceHelper.save(newElement: recipe)
    }
    
    func getCart() throws -> [Recipe] {
        try persistenceHelper.getObjects()
    }
    
    func delete(element: [Recipe], atIndex: Int) throws {
        try persistenceHelper.delete(elements: element, index: atIndex)
    }
}
