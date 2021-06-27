//
//  CarousalViewTableViewCell.swift
//  IlaBankDemo
//
//  Created by webwerks on 24/06/21.
//

import UIKit

class CarousalViewTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    private let collectionMargin = CGFloat(0)
    private let itemSpacing = CGFloat(0)
    private var itemWidth = CGFloat(0)
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        pageControl.numberOfPages = 2
        registerCollectionViewCell()
        setCollectionView()
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forSection section: Int = 0) {
        setCollectionView(collectionView: collectionView, dataSourceDelegate: dataSourceDelegate, forSection: section)
    }
    
    private func setCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: collectionView.frame.height)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.isPagingEnabled = true
    }
}

extension CarousalViewTableViewCell {
    private func registerCollectionViewCell() {
        self.collectionView.registerNibForCell(CarouselCollectionViewCell.self)
    }
}
