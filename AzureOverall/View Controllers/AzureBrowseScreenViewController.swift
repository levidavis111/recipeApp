//
//  AzureBrowseScreenViewController.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import UIKit

class AzureBrowseScreenViewController: UIViewController {
    
    let recipeClientService = RecipeClientService()

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipes()
        // Do any additional setup after loading the view.
    }
    
    private func getRecipes() {
        recipeClientService.getRecipeData(searchTerm: "cheese") { [weak self](result) in
            switch result {
            case .success(let recipes):
                print(recipes)
            case .failure(let error):
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
