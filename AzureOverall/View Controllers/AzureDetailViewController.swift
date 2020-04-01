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
        
        return stepper
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
        view.addSubview(activityIndicator)
    }
    
    private func constrainSubviews() {
        constrainImageView()
        constrainTitleLabel()
        constrainInfoLabel()
        constrainCartStepper()
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
         recipeTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
         recipeTitleLabel.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width / 1.25)].forEach {$0.isActive = true}
    }
    
    private func constrainInfoLabel() {
        recipeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        [recipeInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         recipeInfoLabel.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: 10),
         recipeInfoLabel.bottomAnchor.constraint(lessThanOrEqualTo: cartStepper.topAnchor, constant: -10),
         recipeInfoLabel.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width / 1.25)].forEach {$0.isActive = true}
    }
    
    private func constrainCartStepper() {
        cartStepper.translatesAutoresizingMaskIntoConstraints = false
        [cartStepper.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         cartStepper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            ].forEach {$0.isActive = true}
    }
    
    private func constrainActivityIndicator(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        [activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)].forEach {$0.isActive = true}
    }

}
