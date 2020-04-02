//
//  AzureCartViewController.swift
//  AzureOverall
//
//  Created by Levi Davis on 4/1/20.
//  Copyright © 2020 Levi Davis. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class AzureCartViewController: UIViewController {
    
    var cart: [Recipe] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AzureCartTableViewCell.self, forCellReuseIdentifier: ResuseIdentifier.AzureCartTableCell.rawValue)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getCartFromFileManager()
        // Do any additional setup after loading the view.
    }

    
    private func getCartFromFileManager() {
        do {
            cart = try CartPersistenceManager.manager.getCart()
        } catch {
            print("Error getting cart: \(error)")
        }
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundView = UIView()
    }
    
}

extension AzureCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return AzureCartTableViewCell()
    }
    
}

extension AzureCartViewController: UITableViewDelegate {}

extension AzureCartViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let titleString = "No Recipes in Cart"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 25)]
        return NSAttributedString(string: titleString, attributes: titleAttributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let descriptionString = "Recipes saved to cart will show here"
        let descriptionAttributes = [NSAttributedString.Key.font: UIFont.init(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 20)]
        return NSAttributedString(string: descriptionString, attributes: descriptionAttributes)
    }
}
