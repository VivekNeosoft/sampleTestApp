//
//  ListViewController.swift
//  IlaBankDemo
//
//  Created by webwerks on 24/06/21.
//

import UIKit
protocol ListViewControllerDelegateHandler: AnyObject {
    func reloadTableView()
    func reloadSearchTableView()
}

class ListViewController: UIViewController {
    private let viewModel = ListViewModel()
    @IBOutlet weak private var tableView: UITableView!
    
    /// View Controller life Cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserInterface()
    }
}

// MARK: All Functons
extension ListViewController {
    /// set up UI for screen
    private func setUpUserInterface() {
        setComponent()
        registerTableViewCells()
        setData()
    }
    
    /// set the components
    private func setComponent() {
        viewModel.delegate = self
        tableView.setTableView(tableView: tableView, dataSourceDelegate: self)
    }
    
    /// register table view cells
    private func registerTableViewCells() {
        tableView.registerNibForCell(SearchViewTableViewCell.self)
        tableView.registerNibForCell(CarousalViewTableViewCell.self)
        tableView.registerNibForCell(ListViewTableViewCell.self)
    }
    
    /// set screen data
    private func setData() {
        viewModel.setData()
    }
    
    /// set horizontal carousal page controll
    /// - Parameter currentPage: Int (scroll position)
    private func setCarousalCell(currentPage: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? CarousalViewTableViewCell
        cell?.pageControl.currentPage = currentPage
    }
}

// MARK: TableView delegate, datasource methods
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    /// Number of section in table view
    /// - Parameter tableView: tableView
    /// - Returns: Int
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    /// Number of row in table view
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: Int
    /// - Returns: Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(sectionIndex: section)
    }
    
    /// Cells for table view rows
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: IndexPath
    /// - Returns: UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.valueAtRowIndex(indexpath: indexPath)
        switch model.rowType {
        case .carousel:
            guard let cell: CarousalViewTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath) else { return UITableViewCell() }
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forSection: indexPath.section)
            return cell
        case .list:
            guard let cell: ListViewTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath) else { return UITableViewCell() }
            cell.configSetData(model: model)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    /// Height for table view header
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: CGFloat
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerModel = viewModel.valueAtHeaderIndex(sectionIndex: section)
        guard headerModel.headerType == .search else { return 0 }
        return 60
    }
    
    /// Table view header
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: Int
    /// - Returns: UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell: SearchViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchViewTableViewCell.className) as? SearchViewTableViewCell
        else { return UIView() }
        let model = viewModel.valueAtHeaderIndex(sectionIndex: section)
        cell.configSetData(model: model, delegate: self)
        return cell
    }
}

// MARK: UITextField delegate methods
extension ListViewController: UITextFieldDelegate {
    
    /// textfield delegate method to identify text editing begins
    /// - Parameter textField: UITextField
    /// - Returns: Bool
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tableView.contentOffset = CGPoint.zero
        return true
    }
    
    /// delegate method used on retun dismiss keyboard
    /// - Parameter textField: UITextField
    /// - Returns: Bool
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadTableView()
        return true
    }
    
    /// delegate method to identify change in text field
    /// - Parameters:
    ///   - textField: UITextField
    ///   - range: NSRange
    ///   - string: String
    /// - Returns: Bool
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        tableView.contentOffset = CGPoint.zero
        let currentText = ((textField.text as NSString?)?.replacingCharacters(in: range, with: string)) ?? ""
        guard !currentText.isEmpty else { viewModel.removeAllSearchFilter(); return true }
        viewModel.filterListItems(string: currentText)
        return true
    }
}

// MARK: Scroll view delegate methods
extension ListViewController: UIScrollViewDelegate {
    /// delegate method to identify end of horizontal carousal scroll
    /// - Parameter scrollView: UIScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let row = tableView.cellForRow(at: [0,0]) as? CarousalViewTableViewCell else { return }
        for cell in row.collectionView.visibleCells {
            let item  = row.collectionView.indexPath(for: cell)?.item
            guard let val = item else { return }
            viewModel.filterCarousalContent(carousal: ListViewRowCarousalImageType(rawValue: val) ?? .none)
            setCarousalCell(currentPage: val)
        }
    }
    
    /// delegate method to identify scroll begin
    /// - Parameter scrollView: UIScrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
        reloadTableView()
    }
}

// MARK: CollectionView delegate, datasource methods
extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// number of item in a collection view
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - section: Int
    /// - Returns: Int
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSubRows(sectionIndex: section, collectionView: collectionView)
    }
    
    /// Cells for collection view rows
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: IndexPath
    /// - Returns: UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subListModel = viewModel.valueAtSubRowIndex(indexpath: indexPath, collectionView: collectionView)
        guard let cell: CarouselCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath) else { return UICollectionViewCell() }
        cell.configSetData(model: subListModel)
        return cell
    }
    
    /// delegate method to identify size of collection view cells
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - collectionViewLayout: UICollectionViewLayout
    ///   - indexPath: IndexPath
    /// - Returns: CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 160)
    }
    
    /// selection of horizontal carousal scroll
    /// - Parameters:
    ///   - collectionView: UICollectionView
    ///   - indexPath: indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.valueAtSubRowIndex(indexpath: indexPath, collectionView: collectionView)
        viewModel.filterCarousalContent(carousal: model.carousalImageType)
    }
}

// MARK: ListViewController delegate methods
extension ListViewController: ListViewControllerDelegateHandler {
    /// reload second (vertical) list view section
    func reloadSearchTableView() {
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    /// reload table view
    func reloadTableView() {
        tableView.reloadData()
    }
}
