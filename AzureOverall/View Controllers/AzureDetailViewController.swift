//
//  AzureDetailViewController.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import UIKit

class AzureDetailViewController: UIViewController {
    
    var recipe: Recipe?
    private var cart: [Recipe] = []
    private var padding: CGFloat = 10.0
    private var numberInCart: Double = 0 {
        didSet {
            DispatchQueue.main.async {
                self.cartLabel.text = "There are \(self.numberInCart) in your cart"
            }
        }
    }
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-Bold", size: 22)
        return label
    }()
    
    private lazy var recipeInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia", size: 16)
        return label
    }()
    
    private lazy var cartStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.value = 0
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(cartStepperButtonPressed), for: .touchUpInside)
        return stepper
    }()
    
    private lazy var cartLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Georgia", size: 16)
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
        addSubViews()
        constrainSubviews()
        setImage()
        setText()
        getCartFromPersistence()
        setStepperValue()
    }
    
    @objc private func cartStepperButtonPressed(sender: UIStepper!) {
        
        recipe?.numberInCart = cartStepper.value
        numberInCart = cartStepper.value
        
        if let currentRecipe = recipe {
            for index in 0..<cart.count {
                if cart[index].id == currentRecipe.id {
//                    try? CartPersistenceManager.manager.delete(element: cart, atIndex: index)
                    deleteFromCart(from: cart, at: index)
                }
                   }
            if let currentRecipe = recipe {
                saveToCart(recipe: currentRecipe)
            }
        }
    }
    
    private func saveToCart(recipe: Recipe) {
        do {
            try CartPersistenceManager.manager.saveRecipeToCart(recipe: recipe)
        } catch {
            print("Error saving cart: \(error)")
        }
        
    }
    
    private func deleteFromCart(from cart: [Recipe], at index: Int) {
        do {
            try CartPersistenceManager.manager.delete(element: cart, atIndex: index)
        } catch {
            print("Error deleting from file manager: \(error)")
        }
    }
    
    private func getCartFromPersistence() {
        do {
            let savedCart = try CartPersistenceManager.manager.getCart()
            self.cart = savedCart
        } catch {
            print("Error getting cart: \(error)")
        }
    }
    
    private func setStepperValue() {
        if let currentRecipe = recipe {
        
            let existsInCart = currentRecipe.existsInCart()
            switch existsInCart {
            case false:
                cartStepper.value = 0
                numberInCart = 0
            case true:
                for index in 0..<cart.count {
                    if cart[index].id == currentRecipe.id {
                        cartStepper.value = cart[index].numberInCart ?? 0
                        numberInCart = cart[index].numberInCart ?? 0
                    }
                }
                
            default:
                cartStepper.value = 0
                numberInCart = 0
            }
            cartLabel.text = "There are \(self.numberInCart) in your cart"
        }
        
    }
    
    private func setImage() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        if let currentRecipe = recipe {
            let urlString = "https://spoonacular.com/recipeImages/\(currentRecipe.id)-312x231.jpg"
            ImageManager.manager.getImage(urlStr: urlString) { [weak self](result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                        self?.imageView.image = UIImage(named: "noImage")
                        self?.activityIndicator.stopAnimating()
                    case .success(let image):
                        self?.imageView.image = image
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setText() {
        if let currentRecipe = recipe {
            recipeTitleLabel.text = currentRecipe.title
            recipeInfoLabel.text = "Holy Cow! This recipe makes the number \(currentRecipe.servings) total servings in only \(currentRecipe.readyInMinutes) minutes!!!"
        } else {
            recipeTitleLabel.text = "Uh oh!"
            recipeInfoLabel.text = "There's been a mixup in the kitchen! Go back and search again! Sowwy!!!"
        }
    }
    
    private func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(recipeTitleLabel)
        view.addSubview(recipeInfoLabel)
        view.addSubview(cartStepper)
        view.addSubview(cartLabel)
        view.addSubview(activityIndicator)
    }
    
    private func constrainSubviews() {
        constrainImageView()
        constrainTitleLabel()
        constrainInfoLabel()
        constrainCartStepper()
        constrainCartLabel()
        constrainActivityIndicator()
    }
    
    private func constrainImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
         imageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width / 2),
         imageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 4)].forEach {$0.isActive = true}
    }
    
    private func constrainTitleLabel() {
        recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        [recipeTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         recipeTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
         recipeTitleLabel.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width / 1.25)].forEach {$0.isActive = true}
    }
    
    private func constrainInfoLabel() {
        recipeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        [recipeInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         recipeInfoLabel.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: padding),
         recipeInfoLabel.bottomAnchor.constraint(lessThanOrEqualTo: cartStepper.topAnchor, constant: -padding),
         recipeInfoLabel.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width / 1.25)].forEach {$0.isActive = true}
    }
    
    private func constrainCartStepper() {
        cartStepper.translatesAutoresizingMaskIntoConstraints = false
        [cartStepper.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         cartStepper.bottomAnchor.constraint(equalTo: cartLabel.topAnchor, constant: -padding)
            ].forEach {$0.isActive = true}
    }
    
    private func constrainCartLabel() {
        cartLabel.translatesAutoresizingMaskIntoConstraints = false
        [cartLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         cartLabel.topAnchor.constraint(equalTo: cartStepper.bottomAnchor, constant: padding),
         cartLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)].forEach {$0.isActive = true}
    }
    
    private func constrainActivityIndicator(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        [activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)].forEach {$0.isActive = true}
    }

}
