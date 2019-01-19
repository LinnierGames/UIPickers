//
//  ViewController.swift
//  UIPickers
//
//  Created by linniergames on 05/17/2018.
//  Copyright (c) 2018 linniergames. All rights reserved.
//

import UIKit
import UIPickers

struct Employee {
    let name: String
}

extension Employee: Resource {
    var title: String {
        return self.name
    }
}

struct EmployeeHandbook: UIResourceViewControllerResourcer {
    var resources: [Resource] {
        return [
            Employee(name: "Erick"),
            Employee(name: "Noah"),
            Employee(name: "Nils"),
            Employee(name: "Charels"),
            Employee(name: "Sara"),
            Employee(name: "Lani"),
            Employee(name: "Karen"),
            Employee(name: "Shane"),
        ]
    }
    
    var predicateSearch: (Resource, String) -> Bool {
        return { employee, searchTerm in
            return employee.title.lowercased().contains(searchTerm.lowercased())
        }
    }
}

struct EmployeeNetwork: UIAsyncResourceViewControllerResourcer {
    func fetchResources(completion: @escaping ([Resource]) -> Void) {
        DispatchQueue.global().async {
            sleep(2)
            
            DispatchQueue.main.async {
                completion([
                    Employee(name: "Erick"),
                    Employee(name: "Noah"),
                    Employee(name: "Nils"),
                    Employee(name: "Charels"),
                    Employee(name: "Sara"),
                    Employee(name: "Lani"),
                    Employee(name: "Karen"),
                    Employee(name: "Shane"),
                    ]
                )
            }
        }
    }
}

class ViewController: UIViewController {
    
    let entries: [UIEntryPickerView.Entry] = [
        .major(with: "None"), .minor(with: "15min"), .minor(with: "30min"), .minor(with: "45min"),
        .major(with: "1hr"), .minor(with: "1hr 30min"),
        .minor(with: "2hr"), .minor(with: "2hr 30min"),
        .minor(with: "3hr"), .minor(with: "3hr 30min"),
        .minor(with: "4hr"), .minor(with: "4hr 30min"),
        .minor(with: "5hr"), .minor(with: "5hr 30min"),
        .minor(with: "6hr"), .minor(with: "6hr 30min"),
        .minor(with: "7hr"), .minor(with: "7hr 30min"),
        .minor(with: "8hr")
    ]
    
    let names: [String] = [
        "Hennry",
        "Billy",
        "George",
        "Juan",
        "Jimmy",
        "Mike",
        "Sarah",
        "Chad",
        "Stephanie"
    ]
    
    var filtedNames: [String]?
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    @IBAction func pressPicker(_ sender: Any) {
        let vc = UIPickerViewController(headerText: "Header label", messageText: "message label")
        let action1 = UIPickerAction(title: "Dismiss Button Title") { (action) in
            print("press dismiss")
        }
        
        let cancelAction = UIPickerAction(title: "Cancel", style: .cancel)
        vc.addAction(cancelAction)
        vc.addAction(action1)
        vc.addAction(action1)
        vc.addAction(action1)
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var buttonEntryPicker: UIButton!
    @IBAction func pressEntryPicker(_ sender: Any) {
        let vc = UIEntryPickerViewController(headerText: "Duration", messageText: "How long will this task take to complete", values: entries)
        vc.delegate = self
        vc.defaultEntryIndex = 4
        
        let cancelAction = UIPickerAction(title: "Done")
        vc.addAction(cancelAction)
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var buttonDateAndTimePicker: UIButton!
    @IBAction func pressDateAndTimePicker(_ sender: Any) {
        let vc = UICalendarDatePickerViewController(headerText: "Deadline", messageText: "When is this task due", date: Date(timeIntervalSince1970: 1))
        vc.delegate = self
        
        let cancelAction = UIPickerAction(title: "Done")
        vc.addAction(cancelAction)
        self.present(vc, animated: true)
    }
    
    @IBAction func pressTablePicker(_ sender: Any) {
        let vc = UITablePickerViewController(headerText: "Table View", messageText: "this is abstract class")
        
        let cancelAction = UIPickerAction(title: "Done")
        vc.addAction(cancelAction)
        self.present(vc, animated: true)
    }
    
    @IBAction func pressSearchTablePicker(_ sender: Any) {
//        let vc = UISearchTablePickerViewController(headerText: "Search for things", messageText: "search the data")
//        vc.dataSource = self
//        vc.delegate = self
//
//        let doneAction = UIPickerAction(title: "Done")
//        vc.addAction(doneAction)
//        let cancelAction = UIPickerAction.init(title: "Cancel", style: .cancel)
//        vc.addAction(cancelAction)
//        self.present(vc, animated: true)
    }
    
    @IBAction func pressResourceSearchTablePicker(_ sender: Any) {
        let employeeStack = EmployeeHandbook()
        let vc = UIResourceViewController(headerText: "Employees", messageText: "select an employee", resourcer: employeeStack)
        
        let cancelAction = UIPickerAction.init(title: "Cancel", style: .cancel)
        vc.addAction(cancelAction)
        self.present(vc, animated: true)
    }
    
    @IBAction func pressAsyncResourceSearchTablePicker(_ sender: Any) {
        let employeeStack = EmployeeNetwork()
        let vc = UIAsyncResourceViewController(headerText: "Employees", messageText: "select an employee", asyncResourcer: employeeStack)
        vc.delegate = self
        
        let cancelAction = UIPickerAction.init(title: "Cancel", style: .cancel)
        vc.addAction(cancelAction)
        self.present(vc, animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
}

extension ViewController: UIEntryPickerViewControllerDelegate {
    func entryPicker(_ entryPickerViewController: UIEntryPickerViewController, didFinishWith selectedIndex: Int) {
        print(entries[selectedIndex].text)
    }
}

extension ViewController: UICalendarDatePickerViewControllerDelegate {
    func calendarDatePicker(_ calendarDatePicker: UICalendarDatePickerViewController, didFinishWith selectedDate: Date, timeIncluded: Bool) {
        print(selectedDate, calendarDatePicker.isTimeIncluded)
    }
}

//extension ViewController: UISearchTablePickerViewControllerDataSource {
//    func numberOfSections(in tableView: UITableView, searchTerm: String?) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int, searchTerm: String?) -> Int {
//        return filtedNames?.count ?? names.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, searchTerm: String?) -> UITableViewCell {
//        let cell: UITableViewCell
//        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
//            cell = dequeuedCell
//        } else {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        }
//
//        let names = self.filtedNames ?? self.names
//        cell.textLabel!.text = names[indexPath.row]
//
//        return cell
//    }
//}
//
//extension ViewController: UISearchTablePickerViewControllerDelegate {
//    func searchBar(_ searchBar: UISearchBar, didChange searchTerm: String?) {
//        guard let searchTerm = searchTerm, searchTerm.isEmpty == false else {
//            return filtedNames = nil
//        }
//
//        filtedNames = names.filter { $0.contains(searchTerm) }
//    }
//}

extension ViewController: UIAsyncResourceViewControllerDelegate {
    func resource(_ picker: UIAsyncResourceViewController, didSelect resource: Resource) {
        self.dismiss(animated: true)
        
        if let employee = resource as? Employee {
            print("Selected employee is: ", employee.name)
        }
    }
}
