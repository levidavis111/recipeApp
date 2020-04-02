//
//  AzureCartViewController.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import UIKit

class AzureCartViewController: UIViewController {
    
    private var cart: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.tableView.reloadData()
                self?.checkDataSet()
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AzureCartTableViewCell.self, forCellReuseIdentifier: ResuseIdentifier.AzureCartTableCell.rawValue)
        return tableView
    }()
    
    private lazy var emptyTextHeader: UILabel = {
        let label = UILabel()
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 25)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "No Recipes in Cart"
        return label
    }()
    
    private lazy var emptyTextDescrption: UILabel = {
        let label = UILabel()
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 20)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "Recipes in cart will appear here"
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getCartFromFileManager()
        addSubviews()
        contrainSubviews()
        setDelegates()
        checkDataSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCartFromFileManager()
        checkDataSet()
    }
    
    private func getCartFromFileManager() {
        do {
            cart = try CartPersistenceManager.manager.getCart()
            print(cart.count)
        } catch {
            print("Error getting cart: \(error)")
        }
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func checkDataSet() {
        DispatchQueue.main.async {[weak self] in
            if self?.cart.count == 0 {
                self?.tableView.isHidden = true
                self?.emptyTextHeader.isHidden = false
                self?.emptyTextDescrption.isHidden = false
            } else {
                self?.tableView.isHidden = false
                self?.emptyTextHeader.isHidden = true
                self?.emptyTextDescrption.isHidden = true
            }
        }
        
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(emptyTextHeader)
        view.addSubview(emptyTextDescrption)
        view.addSubview(activityIndicator)
    }
    
    private func contrainSubviews() {
        constrainTableView()
        constrainEmptyTextHeader()
        constrainEmptyTextDescription()
        constrainActivityIndicator()
    }
    
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)].forEach {$0.isActive = true}
    }
    
    private func constrainEmptyTextHeader() {
        emptyTextHeader.translatesAutoresizingMaskIntoConstraints = false
        [emptyTextHeader.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         emptyTextHeader.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20)].forEach {$0.isActive = true}
    }
    
    private func constrainEmptyTextDescription() {
        emptyTextDescrption.translatesAutoresizingMaskIntoConstraints = false
        [emptyTextDescrption.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         emptyTextDescrption.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20)].forEach {$0.isActive = true}
    }
    
    private func constrainActivityIndicator(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        [activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)].forEach {$0.isActive = true}
    }
    
}

extension AzureCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResuseIdentifier.AzureCartTableCell.rawValue, for: indexPath) as? AzureCartTableViewCell else {return UITableViewCell()}
        let oneRecipe = cart[indexPath.row]
        let urlString = "https://spoonacular.com/recipeImages/\(oneRecipe.id)-240x150.jpg"
        cell.recipeTitle.text = oneRecipe.title
        cell.recipeInfo.text = "There are \(Int(oneRecipe.numberInCart ?? 0)) in the cart"
        
        ImageManager.manager.getImage(urlStr: urlString) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Error getting image: \(error)")
                    cell.recipeImageView.image = UIImage(named: "noImage")
                case .success(let image):
                    cell.recipeImageView.image = image
                }
            }
        }
        
        return cell
    }
    
}

extension AzureCartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = AzureDetailViewController()
        let oneRecipe = cart[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}
