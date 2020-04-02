//
//  RecipeClientService.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import Foundation

class RecipeClientService {
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getRecipeData(searchTerm: String, completion: @escaping (Result<[Recipe], AppError>) -> ()) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://api.spoonacular.com/recipes/search") {

            urlComponents.queryItems = [
                URLQueryItem(name: "query", value: "\(searchTerm)"),
                URLQueryItem(name: "number", value: "4"),
                URLQueryItem(name: "apiKey", value: "\(Secret.apiKey)")
            ]
  
            guard let url = urlComponents.url else {return}
            
            dataTask = session.dataTask(with: url) {[weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                if let error = error {
                    print(error)
                } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    let results = self?.getRecipes(from: data)
                    
                    if let recipes = results {
                        completion(.success(recipes))
                    } else {
                        completion(.failure(.invalidJSONResponse))
                    }
                }
                
            }
            dataTask?.resume()
        }
    }
    
    func getRecipes(from data: Data) -> [Recipe] {
        
        do {
            let response = try JSONDecoder().decode(RecipeWrapper.self, from: data)
            return response.results
        } catch {
            print(error)
        }
        return []
    }
}
