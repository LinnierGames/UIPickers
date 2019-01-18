//
//  UITablePickerViewController.swift
//  FBSnapshotTestCase
//
//  Created by Erick Sanchez on 1/18/19.
//

import UIKit

class UITablePickerViewController: UIPickerViewController {
    
    // MARK: - VARS
    
    public lazy var tableView: UITableView = {
        let table: UITableView = UITableView.initProgrammatically(from: { .init(frame: .zero, style: .plain) })
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
//    override init(headerText: String?, messageText: String?) {
//        <#code#>
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - RETURN VALUES
    
    override func layoutContent() -> [UIView] {
        return [tableView]
    }
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE

}

extension UITablePickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("\(#function) not implemented")
    }
}

extension UITablePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
