//
//  UICalendarDatePickerViewController.swift
//  UIEntryPicker
//
//  Created by Erick Sanchez on 5/15/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit

@objc public protocol UICalendarDatePickerViewControllerDelegate: UIDatePickerViewControllerDelegate {
    @objc optional func calendarDatePicker(_ calendarDatePicker: UICalendarDatePickerViewController, didFinishWith selectedDate: Date, timeIncluded: Bool)
}

public class UICalendarDatePickerViewController: UIDatePickerViewController {
    
    public var isTimeIncluded: Bool = false {
        didSet {
            updateTimeButtonTitle()
        }
    }
    
    public weak var calendarDelegate: UICalendarDatePickerViewControllerDelegate? {
        set { self.delegate = newValue }
        get { return self.delegate as! UICalendarDatePickerViewControllerDelegate? }
    }
    
    //TODO: require time or exclude time
    private var canAddTime: Bool = false
    private var isTimeRequired: Bool = false
    
    private lazy var addTimeButton: UIOptionButton = {
        let button = UIOptionButton(type: .TitleButtonAndClearAction)
        button.delegate = self
        
        return button
    }()
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    public override func layoutContent() -> [UIView] {
        
        //TODO: configure datePickerView
        
        let content = super.layoutContent()
        
        return content + [addTimeButton]
    }
    
    private func updateTimeButtonTitle() {
        if isTimeIncluded {
            addTimeButton.buttonTitle = self.date.formattedStringWith(.Time_noPadding_am_pm)
            addTimeButton.isShowingClearButton = true
        } else {
            addTimeButton.buttonTitle = "Add a Time"
            addTimeButton.isShowingClearButton = false
        }
    }
    
    // MARK: - IBACTIONS
    
    public override func pressDone(button: UIButton) {
        calendarDelegate?.calendarDatePicker?(self, didFinishWith: self.date, timeIncluded: self.isTimeIncluded)
    }
    
    // MARK: - LIFE CYCLE
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTimeButtonTitle()
    }
}

extension UICalendarDatePickerViewController: UIOptionButtonDelegate {
    public func optionButton(_ optionButton: UIOptionButton, didPressTitle button: UIButton) {
        let timePickerVc = UIDatePickerViewController(
            headerText: nil,
            messageText: "select a time",
            date: self.date
        )
        timePickerVc.datePickerMode = .time
        
        //if adding a new time, set only the time of `self.date` to `Date()`
        if isTimeIncluded == false {
            let timeDate = self.date.equating(to: Date(), by: [.hour, .minute])
            timePickerVc.date = timeDate
        }
        
        timePickerVc.addAction(UIPickerAction(title: "Done", action: { [weak self] (action) in
            guard let unwrappedSelf = self else { return }
            
            //update self.date with only the time from UIDatePickerVc
            unwrappedSelf.date = timePickerVc.date
            unwrappedSelf.updateTimeButtonTitle()
        }))
        
        self.present(timePickerVc, animated: true) { [unowned self] in
            self.isTimeIncluded = true
        }
    }
    
    public func optionButton(_ optionButton: UIOptionButton, didPressClear button: UIButton) {
        isTimeIncluded = false
    }
}

//////////////////////////////////////////////////////////
//
// MARK: - UIDatePickerViewController
//
//////////////////////////////////////////////////////////

@objc public protocol UIDatePickerViewControllerDelegate: class {
    @objc optional func datePicker(_ datePicker: UIDatePickerViewController, didFinishWith selectedDate: Date)
}

public class UIDatePickerViewController: UIPickerViewController {
    
    public weak var delegate: UIDatePickerViewControllerDelegate?
    
    public var datePickerMode: UIDatePickerMode = .date
    
    public var date: Date {
        didSet {
            self.datePickerView.setDate(self.date, animated: true)
        }
    }
    
    public fileprivate(set) lazy var datePickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = self.datePickerMode
        pickerView.date = self.date
        pickerView.addTarget(self, action: #selector(changedDatePickerValue(_:)), for: .valueChanged)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.heightAnchor.constraint(equalTo: pickerView.widthAnchor, multiplier: 0.33).isActive = true
        
        return pickerView
    }()
    
    public init(headerText: String?, messageText: String? = "", date: Date) {
        self.date = date
        
        super.init(headerText: headerText, messageText: messageText)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.date = Date()
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    public override func layoutContent() -> [UIView] {
        return [datePickerView]
    }
    
    public override func pressDone(button: UIButton) {
        delegate?.datePicker?(self, didFinishWith: self.date)
    }
    
    @objc private func changedDatePickerValue(_ datePicker: UIDatePicker) {
        self.date = datePicker.date
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
}
