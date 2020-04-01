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
    
    private let cellSpacing: CGFloat = 10.0
    
    private let recipeClientService = RecipeClientService()
    private var searchTerm: String = "" {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.getRecipes()
            }
        }
    }
    
    private var recipes: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let collectionView = (UICollectionView(frame: .zero, collectionViewLayout: layout))
        collectionView.register(AzureBrowseCollectionViewCell.self, forCellWithReuseIdentifier: ResuseIdentifier.AzureBrowseCollectionCell.rawValue)
        collectionView.backgroundColor = .white
        return collectionView
        
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        constrainSubviews()
        setDelegates()
        
    }
    
    private func getRecipes() {
        recipeClientService.getRecipeData(searchTerm: searchTerm) { [weak self](result) in
            DispatchQueue.main.async {
                self?.activityIndicator.startAnimating()
            }
            switch result {
            case .success(let recipes):
                self?.recipes = recipes
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setDelegates() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        collectionView.backgroundView = UIView()
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.addSubview(activityIndicator)
    }
    
    private func constrainSubviews() {
        constrainSearchBar()
        constrainCollectionView()
        constrainActivityIndicator()
    }
    
    private func constrainSearchBar(){
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        [searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach {$0.isActive = true}
    }
    
    private func constrainCollectionView(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        [collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach {$0.isActive = true}
    }
    
    private func constrainActivityIndicator(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        [activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)].forEach {$0.isActive = true}
    }

}

extension AzureBrowseScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResuseIdentifier.AzureBrowseCollectionCell.rawValue, for: indexPath) as? AzureBrowseCollectionViewCell else {return UICollectionViewCell()}
        
        let oneRecipe = recipes[indexPath.row]
        let imageUrl = "https://spoonacular.com/recipeImages/\(oneRecipe.id)-240x150.jpg"
        
        cell.imageView.image = UIImage(systemName: "person")
        cell.recipeTitle.text = oneRecipe.title
        cell.recipeInfo.text = "Makes \(oneRecipe.servings) servings in \(oneRecipe.readyInMinutes) minutes!"
        
        ImageManager.manager.getImage(urlStr: imageUrl) {(result) in
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(named: "noImage")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    
                }
            }
        }
        
        return cell
    }
    
}

extension AzureBrowseScreenViewController: UICollectionViewDelegate {}

extension AzureBrowseScreenViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let numCells: CGFloat = 1
    let numSpaces: CGFloat = numCells + 1
    
    let screenWidth = UIScreen.main.bounds.width
    let screenheight = UIScreen.main.bounds.height
    
    return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenheight / 2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
}

extension AzureBrowseScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchEntry = searchBar.text {
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.startAnimating()
            }
            self.searchTerm = searchEntry
        } else {
            self.searchTerm = ""
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



extension AzureBrowseScreenViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let titleString = "No Recipes Loaded"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 25)]
        return NSAttributedString(string: titleString, attributes: titleAttributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let descriptionString = "Search results will show here"
        let descriptionAttributes = [NSAttributedString.Key.font: UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 20)]
        return NSAttributedString(string: descriptionString, attributes: descriptionAttributes)
    }
}
