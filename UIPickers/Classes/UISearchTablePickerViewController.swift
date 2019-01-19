//
//  UISearchTablePickerViewController.swift
//  FBSnapshotTestCase
//
//  Created by Erick Sanchez on 1/18/19.
//

import UIKit

open class UISearchTablePickerViewController: UITablePickerViewController {

    // MARK: - VARS
    
    public var reloadTableViewOnSearchUpdates = true
    
    public private(set) lazy var searchBar: UISearchBar = {
        let sb: UISearchBar = UISearchBar.initProgrammatically()
        sb.cannotCompressInContentView()
        
        sb.delegate = self
        
        return sb
    }()
    
    // MARK: - RETURN VALUES
    
    override open func layoutContent() -> [UIView] {
        
        // this contains the table view
        let superContent = super.layoutContent()
        
        return [searchBar] + superContent
    }
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

}

extension UISearchTablePickerViewController: UISearchBarDelegate {
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if reloadTableViewOnSearchUpdates {
            tableView.reloadData()
        }
    }
}
