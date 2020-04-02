//
//  AzureBrowseCollectionViewCell.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import UIKit

class AzureBrowseCollectionViewCell: UICollectionViewCell {
    
//    MARK:- Instance Variables
    
    private let padding: CGFloat = 10.0
    
//    MARK:- Instatiate UI Elements
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var recipeTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "Georgia-Bold", size: 18)
        return label
    }()
    
    lazy var recipeInfo: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia", size: 12)
        return label
    }()
    
//    MARK:- Override Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        contrainSubviews()
        roundCellCorners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK:- Private Methods
    
    private func roundCellCorners() {
        let shadowOffset = CGSize(width: 0, height: 2)
        
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
        layer.shadowPath = shadowPath
        
        contentView.layoutIfNeeded()
    }
    
//    MARK:- Constrain UI Elements
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(recipeTitle)
        contentView.addSubview(recipeInfo)
    }
    
    private func contrainSubviews() {
        constrainImageView()
        constrainRecipeTitle()
        contrainRecipeInfo()
    }
    
    private func constrainImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        [imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor), imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
         imageView.widthAnchor.constraint(equalToConstant: contentView.safeAreaLayoutGuide.layoutFrame.width / 1.5),
         imageView.heightAnchor.constraint(equalToConstant: contentView.safeAreaLayoutGuide.layoutFrame.height / 2)].forEach {$0.isActive = true}
    }
    
    private func constrainRecipeTitle() {
        recipeTitle.translatesAutoresizingMaskIntoConstraints = false
        [recipeTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
         recipeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
         recipeTitle.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding)].forEach {$0.isActive = true}
    }
    
    private func contrainRecipeInfo() {
        recipeInfo.translatesAutoresizingMaskIntoConstraints = false
        [recipeInfo.topAnchor.constraint(equalTo: recipeTitle.bottomAnchor, constant: padding),
         recipeInfo.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
         recipeInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
         recipeInfo.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -padding)].forEach {$0.isActive = true}
    }
}
