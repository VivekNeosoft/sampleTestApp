//
//  ListViewModel.swift
//  IlaBankDemo
//
//  Created by webwerks on 24/06/21.
//

import Foundation
import  UIKit

/// Enum to identify type of section
enum ListViewHeaderType: Int {
    case search
    case none
}

/// enum to identify row type
enum ListViewRowType: Int {
    case carousel
    case list
    case none
}

/// enum to identify horizontal carousal
enum ListViewRowCarousalImageType: Int {
    case bike = 0
    case cars = 1
    case none = 2
}

/// Methods related to table view
protocol ListViewModelTableViewProtocol: AnyObject {
    func numberOfSection() -> Int
    func numberOfRows(sectionIndex: Int) -> Int
    func numberOfSubRows(sectionIndex: Int, collectionView: UICollectionView) -> Int
    func valueAtHeaderIndex(sectionIndex: Int) -> ListViewHeaderModel
    func valueAtRowIndex(indexpath: IndexPath) -> ListViewRowModel
    func valueAtSubRowIndex(indexpath: IndexPath, collectionView: UICollectionView) -> ListViewSubRowModel
}

/// Methods related to business logic & operations
protocol ListViewModelOperationsProtocol: AnyObject {
    func setData()
    func filterCarousalContent(carousal: ListViewRowCarousalImageType)
    func filterListItems(string: String)
    func removeAllSearchFilter()
}

class ListViewModel {
    private (set) var listViewModelArray = [ListViewHeaderModel]()
    private (set) var listViewModelArrayCopy = [ListViewHeaderModel]()
    private (set) var listViewModelArrayFilterCopy = [ListViewHeaderModel]()
    private let bikeArray: [String] = ["Royal Enfield bike", "KTM bike", "TVS Apache bike", "TVS RTR 180 bike", "TVS RTR 220 Apache", "Yamaha YZF Apache", "Hero Splendor Plus bike", "Passion bike", "Pulsar 220 bike", "Pulsar 120 bike", "Pulsar 125 bike", "Pulsar 180 bike", "Pulsar 150 bike", "Avenger", "Bullet 350 Apache", "Bullet 250 Apache"]
    private let carsArray: [String] = ["Maruti Suzuki Hyundai cars", "Honda Toyota cars", "Mahindra Kia cars"]
    weak var delegate: ListViewControllerDelegateHandler?
}

extension ListViewModel: ListViewModelOperationsProtocol {
    /// initial data setup, this data suppose to come from API
    func setData() {
        var rowModel = [ListViewRowModel]()
        var subRowModel = [ListViewSubRowModel]()
        subRowModel.append(ListViewSubRowModel(image: "bikeImage", carousalImageType: .bike))
        subRowModel.append(ListViewSubRowModel(image: "carImage", carousalImageType: .cars))
        rowModel.append(ListViewRowModel(subRowModel: subRowModel, rowType: .carousel))
        listViewModelArray.append(ListViewHeaderModel(rowModel: rowModel))
        
        rowModel.removeAll()
        bikeArray.forEach { (bike) in
            rowModel.append(ListViewRowModel(image: "dummyImage", title: "\(bike)", rowType: .list, carousalImageType: .bike))
        }
        carsArray.forEach { (car) in
            rowModel.append(ListViewRowModel(image: "dummyImage", title: "\(car)", rowType: .list, carousalImageType: .cars))
        }
    
        listViewModelArray.append(ListViewHeaderModel(textfieldPlaceholder: "Search", rowModel: rowModel, headerType: .search))
        listViewModelArrayCopy = listViewModelArray
        filterCarousalContent(carousal: .bike)
        delegate?.reloadTableView()
    }
    
    /// filter horizontal carausal
    /// - Parameter carousal: passing the type carausal (eg, car, bike)
    func filterCarousalContent(carousal: ListViewRowCarousalImageType) {
        for (headerIndex, headerModel) in listViewModelArrayCopy.enumerated() where headerModel.headerType == .search {
            listViewModelArray[headerIndex].rowModel = listViewModelArrayCopy[headerIndex].rowModel.filter { $0.carousalImageType == carousal}            
        }
        listViewModelArrayFilterCopy = listViewModelArray
        delegate?.reloadTableView()
    }
    
    /// filter table view list
    /// - Parameter string: string to filter
    func filterListItems(string: String) {
        for (headerIndex, headerModel) in listViewModelArrayFilterCopy.enumerated() where headerModel.headerType == .search {
            listViewModelArray[headerIndex].rowModel = listViewModelArrayFilterCopy[headerIndex].rowModel.filter { $0.title.lowercased().contains(string.lowercased())}
        }
        delegate?.reloadSearchTableView()
    }
    
    /// remove all searches filter, this this for blank text field
    func removeAllSearchFilter() {
        listViewModelArray = listViewModelArrayFilterCopy
        delegate?.reloadSearchTableView()
    }
}

extension ListViewModel: ListViewModelTableViewProtocol {
    
    /// use to get value at heder index
    /// - Parameter sectionIndex: sectionIndex
    /// - Returns: HomeHeaderModel
    func valueAtHeaderIndex(sectionIndex: Int) -> ListViewHeaderModel {
        return listViewModelArray[sectionIndex]
    }
    
    /// use to get value at sub row index
    /// - Parameters:
    ///   - indexpath: indexpath
    ///   - collectionView: collectionview
    /// - Returns: HomeSubRowModel
    func valueAtSubRowIndex(indexpath: IndexPath, collectionView: UICollectionView) -> ListViewSubRowModel {
        return listViewModelArray[collectionView.tag].rowModel[listViewModelArray[collectionView.tag].rowModel.count - 1].subRowModel[indexpath.item]
    }
    
    /// number of subrows
    /// - Parameters:
    ///   - sectionIndex: sectionIndex
    ///   - collectionView: collectionView
    /// - Returns: Int
    func numberOfSubRows(sectionIndex: Int, collectionView: UICollectionView) -> Int {
        return listViewModelArray[collectionView.tag].rowModel[listViewModelArray[collectionView.tag].rowModel.count - 1].subRowModel.count
    }
    
    /// value at row index
    /// - Parameter indexpath: indexpath
    /// - Returns: HomeRowModel
    func valueAtRowIndex(indexpath: IndexPath) -> ListViewRowModel {
        return listViewModelArray[indexpath.section].rowModel[indexpath.row]
    }
    
    /// number of sections
    /// - Returns: Int
    func numberOfSection() -> Int {
        return listViewModelArray.count
    }
    
    /// number of rows
    /// - Parameter sectionIndex: sectionIndex
    /// - Returns: Int
    func numberOfRows(sectionIndex: Int) -> Int {
        return listViewModelArray[sectionIndex].rowModel.count
    }
}

struct ListViewHeaderModel {
    private(set) var textfieldPlaceholder: String = ""
    var rowModel = [ListViewRowModel]()
    private(set) var headerType: ListViewHeaderType = .none
    init(textfieldPlaceholder: String = "", rowModel: [ListViewRowModel] = [ListViewRowModel](), headerType: ListViewHeaderType = .none) {
        self.textfieldPlaceholder = textfieldPlaceholder
        self.rowModel = rowModel
        self.headerType = headerType
    }
}

struct ListViewRowModel {
    private(set) var image: String = ""
    private(set) var title: String = ""
    private(set) var subRowModel = [ListViewSubRowModel]()
    private(set) var carousalImageType: ListViewRowCarousalImageType = .none
    private(set) var rowType: ListViewRowType = .none
    init(image: String = "", title: String = "", subRowModel: [ListViewSubRowModel] = [ListViewSubRowModel](), rowType: ListViewRowType = .none, carousalImageType: ListViewRowCarousalImageType = .none) {
        self.title = title
        self.image = image
        self.subRowModel = subRowModel
        self.rowType = rowType
        self.carousalImageType = carousalImageType
    }
}

struct ListViewSubRowModel {
    private(set) var image: String = ""
    private(set) var carousalImageType: ListViewRowCarousalImageType = .none
    init(image: String = "", carousalImageType: ListViewRowCarousalImageType = .none) {
        self.image = image
        self.carousalImageType = carousalImageType
    }
}
