//
//  CarouselCollectionViewCell.swift
//  IlaBankDemo
//
//  Created by webwerks on 24/06/21.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var imgView: UIImageView!
}

extension CarouselCollectionViewCell {
    func configSetData(model: ListViewSubRowModel) {
        imgView.image = UIImage(named: model.image)
    }
}
