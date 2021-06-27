//
//  Extensions.swift
//  IlaBankDemo
//
//  Created by webwerks on 27/06/21.
//

import  UIKit
extension UIView {
    static var className: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    final func setCollectionView(collectionView: UICollectionView, dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forSection section: Int = 0 ) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = section
        collectionView.reloadData()
    }
}

extension UITableView {
   final func registerNibForCell<T: UITableViewCell>(_ cell: T.Type) {
        let cellNib = UINib(nibName: T.className, bundle: nil)
        register(cellNib, forCellReuseIdentifier: T.className)
    }

    final func dequeueReusableCellForIndexPath<T: UITableViewCell>(_ indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T
    }
    
    final func setTableView(tableView: UITableView, dataSourceDelegate: UITableViewDataSource & UITableViewDelegate) {
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 100
    }
}

extension UICollectionView {
    func registerNibForCell<T: UICollectionViewCell>(_ cell: T.Type) {
        let cellNib = UINib(nibName: T.className, bundle: nil)
        register(cellNib, forCellWithReuseIdentifier: T.className)
    }

    func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as? T
    }
}
