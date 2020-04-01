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
        label.font = UIFont(name: "Georgia-Bold", size: 22)
        return label
    }()
    
    private lazy var recipeInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        constrainSubviews()
        setImage()
        print(recipe!)
    }
    
    private func setImage() {
        if let currentRecipe = recipe {
            let urlString = "https://spoonacular.com/recipeImages/\(currentRecipe.id)-312x231.jpg"
            ImageManager.manager.getImage(urlStr: urlString) { [weak self](result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print(error)
                        self?.imageView.image = UIImage(named: "noImage")
                    case .success(let image):
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
    private func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(recipeTitleLabel)
        view.addSubview(recipeInfoLabel)
        view.addSubview(cartStepper)
    }
    
    private func constrainSubviews() {
        constrainImageView()
        constrainTitleLabel()
        constrainInfoLabel()
        constrainCartStepper()
    }
    
    private func constrainImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
         imageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width / 2),
         imageView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 4)].forEach {$0.isActive = true}
    }
    
    private func constrainTitleLabel() {
        
    }
    
    private func constrainInfoLabel() {}
    
    private func constrainCartStepper() {}

}
