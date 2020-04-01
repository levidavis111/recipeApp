//
//  AzureBrowseScreenViewController.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class AzureBrowseScreenViewController: UIViewController {
    
    private let recipeClientService = RecipeClientService()
    private var searchTerm: String = ""
    
    private var recipes: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {
                print("hi")
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipes()
        // Do any additional setup after loading the view.
    }
    
    private func getRecipes() {
        recipeClientService.getRecipeData(searchTerm: searchTerm) { [weak self](result) in
            switch result {
            case .success(let recipes):
                self?.recipes = recipes
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



extension AzureBrowseScreenViewController: EmptyDataSetSource, EmptyDataSetDelegate {
//    Show a message if the collection view is empty.
    func setupEmptyDataSourceDelegate() {
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        collectionView.backgroundView = UIView()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let titleString = "No Articles Saved"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 25)]
        return NSAttributedString(string: titleString, attributes: titleAttributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let descriptionString = "Saved articles will appear here"
        let descriptionAttributes = [NSAttributedString.Key.font: UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 20)]
        return NSAttributedString(string: descriptionString, attributes: descriptionAttributes)
    }
}
