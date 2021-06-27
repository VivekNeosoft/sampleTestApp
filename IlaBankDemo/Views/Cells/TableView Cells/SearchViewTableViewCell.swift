//
//  SearchViewTableViewCell.swift
//  IlaBankDemo
//
//  Created by webwerks on 24/06/21.
//

import UIKit

class SearchViewTableViewCell: UITableViewCell {

    @IBOutlet weak var searchTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

extension SearchViewTableViewCell {
    func configSetData(model: ListViewHeaderModel, delegate: UITextFieldDelegate? = nil) {
        searchTextField.placeholder = model.textfieldPlaceholder
        searchTextField.delegate = delegate
    }
}
