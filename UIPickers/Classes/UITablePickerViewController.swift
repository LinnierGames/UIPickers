//
//  UITablePickerViewController.swift
//  FBSnapshotTestCase
//
//  Created by Erick Sanchez on 1/18/19.
//

import UIKit

open class UITablePickerViewController: UIPickerViewController {
    
    // MARK: - VARS
    
    public lazy var tableView: UITableView = {
        let table: UITableView = UITableView.initProgrammatically(from: { .init(frame: .zero, style: .plain) })
        table.dataSource = self
        table.delegate = self
        self.tableViewHeightConstraint = table.heightAnchor.constraint(equalToConstant: 196)
        self.tableViewHeightConstraint.priority = UILayoutPriority.defaultHigh
        self.tableViewHeightConstraint.isActive = true
        
        return table
    }()
    
    public var tableViewHeight: CGFloat {
        set {
            tableViewHeightConstraint.constant = newValue
            tableView.superview?.layoutIfNeeded()
        }
        get {
            return tableViewHeightConstraint.constant
        }
    }
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - RETURN VALUES
    
    override open func layoutContent() -> [UIView] {
        return [tableView]
    }
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

}

extension UITablePickerViewController: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("\(#function) not implemented")
    }
}

extension UITablePickerViewController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
