//
//  UISearchTablePickerViewController.swift
//  FBSnapshotTestCase
//
//  Created by Erick Sanchez on 1/18/19.
//

import UIKit

protocol UISearchTablePickerViewControllerDataSource: class {
    
    func numberOfSections(in tableView: UITableView, searchTerm: String?) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int, searchTerm: String?) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, searchTerm: String?) -> UITableViewCell
}

class UISearchTablePickerViewController: UITablePickerViewController {

    // MARK: - VARS
    
    public weak var dataSource: UISearchTablePickerViewControllerDataSource?
    
    public private(set) var searchBar: UISearchBar = {
        let sb: UISearchBar = UISearchBar.initProgrammatically()
        
        return sb
    }()
    
    // MARK: - RETURN VALUES
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = self.dataSource else {
            return super.numberOfSections(in: tableView)
        }
        
        let term: String? = {
            if let text = self.searchBar.text, text.isEmpty == false {
                return text
            } else {
                return nil
            }
        }()
        
        return dataSource.numberOfSections(in: tableView, searchTerm: term)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        let term: String? = {
            if let text = self.searchBar.text, text.isEmpty == false {
                return text
            } else {
                return nil
            }
        }()
        
        return dataSource.tableView(tableView, numberOfRowsInSection: section, searchTerm: term)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = self.dataSource else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        let term: String? = {
            if let text = self.searchBar.text, text.isEmpty == false {
                return text
            } else {
                return nil
            }
        }()
        
        return dataSource.tableView(tableView, cellForRowAt: indexPath, searchTerm: term)
    }
    
    override func layoutContent() -> [UIView] {
        
        // this contains the table view
        let superContent = super.layoutContent()
        
        return [searchBar] + superContent
    }
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

}
