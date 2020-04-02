//
//  AzureCartTableViewCell.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/2/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import UIKit

class AzureCartTableViewCell: UITableViewCell {
    
    let padding: CGFloat = 10.0
    
    lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var recipeTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "Georgia-Bold", size: 20)
        return label
    }()
    
    lazy var recipeInfo: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia", size: 16)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        constrainSubviews()
    }
    
    override func layoutSubviews() {
       roundCellCorners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func addSubviews() {
        contentView.addSubview(recipeImageView)
        contentView.addSubview(recipeTitle)
        contentView.addSubview(recipeInfo)
    }
    
    private func constrainSubviews() {
        constrainRecipeImageView()
        constrainRecipeTitle()
        constrainRecipeInfo()
    }
    
    private func constrainRecipeImageView() {
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        [recipeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor), recipeImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: padding),
         recipeImageView.widthAnchor.constraint(equalToConstant: contentView.safeAreaLayoutGuide.layoutFrame.width / 1.5),
         recipeImageView.heightAnchor.constraint(equalToConstant: 250),
         recipeImageView.bottomAnchor.constraint(equalTo: recipeTitle.topAnchor, constant: -padding)].forEach {$0.isActive = true}
    }
    
    private func constrainRecipeTitle() {
        recipeTitle.translatesAutoresizingMaskIntoConstraints = false
        [recipeTitle.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
         recipeTitle.centerYAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 100)].forEach {$0.isActive = true}
    }
    
    private func constrainRecipeInfo(){
        recipeInfo.translatesAutoresizingMaskIntoConstraints = false
        [recipeInfo.topAnchor.constraint(equalTo: recipeTitle.bottomAnchor, constant: padding),
         recipeInfo.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
         recipeInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
         recipeInfo.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -padding)].forEach {$0.isActive = true}
    }
    
}
