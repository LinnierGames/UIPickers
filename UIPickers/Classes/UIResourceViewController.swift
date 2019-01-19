//
//  UIResourceViewController.swift
//  UIPickers
//
//  Created by Erick Sanchez on 1/19/19.
//

import UIKit

public protocol Resource {
    var title: String { get }
}

public protocol UIResourceViewControllerResourcer {
    var resources: [Resource] { get }
    var predicateSearch: (Resource, String) -> Bool { get }
}

open class UIResourceViewController: UISearchTablePickerViewController {

    // MARK: - VARS
    
    public var resourcer: UIResourceViewControllerResourcer
    
    var filteredResult: [Resource]?
    
    public init(headerText: String?, messageText: String?, resourcer: UIResourceViewControllerResourcer) {
        self.resourcer = resourcer
        
        super.init(headerText: headerText, messageText: messageText)
        
        dataSource = self
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented") //no value for self.resourcer
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

}

extension UIResourceViewController: UISearchTablePickerViewControllerDataSource, UISearchTablePickerViewControllerDelegate {
    
    public func numberOfSections(in tableView: UITableView, searchTerm: String?) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int, searchTerm: String?) -> Int {
        return filteredResult?.count ?? resourcer.resources.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, searchTerm: String?) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = dequeueCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let rows = filteredResult ?? resourcer.resources
        cell.textLabel!.text = rows[indexPath.row].title
        
        return cell
    }
    
    public func searchBar(_ searchBar: UISearchBar, didChange searchText: String?) {
        if let searchText = searchText {
            let predicate = resourcer.predicateSearch
            filteredResult = resourcer.resources.filter { predicate($0, searchText) }
        } else {
            filteredResult = nil
        }
        
        tableView.reloadData()
    }
}
