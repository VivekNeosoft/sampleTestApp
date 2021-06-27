//
//  ListViewTableViewCell.swift
//  IlaBankDemo
//
//  Created by webwerks on 24/06/21.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }    
}

extension ListViewTableViewCell {
    func configSetData(model: ListViewRowModel) {
        imgView.image = UIImage(named: model.image)
        titleLabel.text = model.title
    }
}
