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
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented") //no value for self.resourcer
    }
    
    // MARK: - RETURN VALUES
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResult?.count ?? resourcer.resources.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    // MARK: - METHODS
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rows = filteredResult ?? resourcer.resources
        
        self.resourcePicker(self, didSelect: rows[indexPath.row])
    }
    
    open func resourcePicker(_ picker: UIResourceViewController, didSelect resource: Resource) {
        
    }
    
    open override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            let predicate = resourcer.predicateSearch
            filteredResult = resourcer.resources.filter { predicate($0, searchText) }
        } else {
            filteredResult = nil
        }
        
        if reloadTableViewOnSearchUpdates {
            tableView.reloadData()
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
}
