//
//  UIPickerViewController.swift
//  UIPickers
//
//  Created by Erick Sanchez on 5/15/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit

open class UIPickerViewController: UIViewController {
    
    //    public weak var delegate: UIEntryPickerViewControllerDelegate?
    
    public var headerText: String?
    
    public var messageText: String?
    
    open var dismissButtonTitle: String? = "Done"
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24.0
        sv.alignment = .fill
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    private lazy var containerView: UIView = {
        let container = UIView()
        
        container.layer.cornerRadius = 12.0
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
    }()
    
    public init(headerText: String?, messageText: String? = "") {
        self.headerText = headerText
        self.messageText = messageText
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required public init?(coder aDecoder: NSCoder) {
        headerText = ""
        messageText = ""
        
        super.init(coder: aDecoder)
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    /**
     Override this computed var to add custom views to the internal stack view
     */
    open func layoutConent() -> [UIView] { return [] }
    
    /**
     Override this func to add functionality just before the view controller dismisses
     */
    open func pressDone(button: UIButton) { }
    
    open override func loadView() {
        super.loadView()
        
        //Header label
        if let headerText = self.headerText {
            let headerLabel = UILabel()
            headerLabel.text = headerText
            headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
            headerLabel.textAlignment = .center
            self.stackView.addArrangedSubview(headerLabel)
        }
        
        //Description label
        if let descriptionText = self.messageText {
            let descriptionLabel = UILabel()
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = descriptionText
            descriptionLabel.textAlignment = .center
            self.stackView.addArrangedSubview(descriptionLabel)
        }
        
        self.layoutConent()
            .forEach { [unowned self] (aView) in
                self.stackView.addArrangedSubview(aView)
            }
        
        //ok button
        if let buttonTitle = self.dismissButtonTitle {
            let okButton = UIButton(type: .system)
            okButton.addTarget(self, action: #selector(pressDone(_:)), for: .touchUpInside)
            okButton.setTitle(buttonTitle, for: .normal)
            okButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)
            self.stackView.addArrangedSubview(okButton)
        }
        
        //Layout
        self.containerView.addSubview(self.stackView)
        self.stackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8.0).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 8.0).isActive = true
        
        self.view.addSubview(self.containerView)
        self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 24.0).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 12.0).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0).isActive = true
        self.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16.0).isActive = true
        
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    }
    
    // MARK: - IBACTIONS
    
    @objc private func pressDone(_ button: UIButton) {
        self.pressDone(button: button)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
}
