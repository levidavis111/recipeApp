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
    
    //    MARK:- Instance Variables
    
    private let cellSpacing: CGFloat = 10.0
    
    private let recipeClientService = RecipeClientService()
    private var searchTerm: String = "" {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.stopAnimating()
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
    
    //    MARK:- Intanstiate UI Elements
    
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
    
    //    MARK:- Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        constrainSubviews()
        setDelegates()
        setNavBar()
    }
    
    //    MARK:- Obj-C Methods
    
    @objc private func cartButtonPressed() {
        //        Transition to cartVC
        let cartVC = AzureCartViewController()
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        UIView.transition(from: self.view, to: cartVC.view, duration: 0.8, options: .transitionCrossDissolve) { [weak self](_) in
            
            self?.navigationController?.pushViewController(cartVC, animated: true)
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
        }
    }
    
    //    MARK:- Private Methods
    
    private func getRecipes() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        
        recipeClientService.getRecipeData(searchTerm: searchTerm) { [weak self](result) in
            
            switch result {
            case .success(let recipes):
                self?.recipes = recipes
            case .failure(let error):
                print("Error getting recipes: \(error)")
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
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
    
    //    MARK:- Constrain UI Elements
    
    private func setNavBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(cartButtonPressed))
        
        self.navigationItem.rightBarButtonItem = rightButton
        
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
        //        Set cell properties
        cell.recipeTitle.text = oneRecipe.title
        cell.recipeInfo.text = "Makes \(oneRecipe.servings) servings in \(oneRecipe.readyInMinutes) minutes!"
        //        Get cell images
        ImageManager.manager.getImage(urlStr: imageUrl) {(result) in
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.startAnimating()
                switch result {
                case .failure(let error):
                    print("Error getting image: \(error)")
                    cell.imageView.image = UIImage(named: "noImage")
                    self?.activityIndicator.stopAnimating()
                case .success(let image):
                    cell.imageView.image = image
                    self?.activityIndicator.stopAnimating()
                }
            }
            
        }
        
        return cell
    }
    
}

extension AzureBrowseScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        Transition to detail VC
        let detailVC = AzureDetailViewController()
        let oneRecipe = recipes[indexPath.row]
        detailVC.recipe = oneRecipe
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        
        UIView.transition(from: self.view, to: detailVC.view, duration: 0.8, options: .transitionCrossDissolve) { [weak self](_) in
            
            detailVC.recipe = oneRecipe
            self?.navigationController?.pushViewController(detailVC, animated: true)
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
        }
    }
}

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
    //    Show a message if data set is empty.
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
