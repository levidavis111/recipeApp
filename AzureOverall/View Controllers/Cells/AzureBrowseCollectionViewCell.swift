//
//  AzureBrowseCollectionViewCell.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import UIKit

class AzureBrowseCollectionViewCell: UICollectionViewCell {
    
    let padding: CGFloat = 10.0
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var recipeTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    lazy var recipeInfo: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        contrainSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        [imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
         imageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
         imageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
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
