//
//  UIPickerViewController.swift
//  UIPickers
//
//  Created by Erick Sanchez on 5/15/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit

public enum UIPickerActionStyle : Int {
    case `default`
    
    case cancel
    
    case destructive
}

open class UIPickerAction {
    var title: String
    var style: UIPickerActionStyle
    var action: ((UIPickerAction) -> Void)?
    
    public init(title: String, style: UIPickerActionStyle = .default, action: ((UIPickerAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.action = action
    }
}

open class UIPickerViewController: UIViewController {
    
    deinit {
        print("removed \(type(of: self))")
    }
    
    public var headerText: String?
    
    public var messageText: String?
    
    public private(set) var actions: [UIPickerAction] = []
    
    open var dismissOnActionDidTouchUpInside: Bool = true
    
    private lazy var stackViewButtonActions: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .fill
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    
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
    
    // MARK: - Inits
    
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
    
    public func addAction(_ action: UIPickerAction) {
        self.actions.append(action)
    }
    
    /**
     Override this computed var to add custom views to the internal stack view
     */
    open func layoutContent() -> [UIView] { return [] }
    
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
        
        self.layoutContent()
            .forEach { [unowned self] (aView) in
                self.stackView.addArrangedSubview(aView)
            }
        
        var cancelAction: UIPickerAction?
        if self.actions.count > 0 {
            
            //combine buttons in a seperate stackview
            for anAction in self.actions {
                if case .cancel = anAction.style {
                    if cancelAction == nil {
                        cancelAction = anAction
                        continue
                    } else {
                        preconditionFailure("only one cancel button can be in an picker view controller")
                    }
                }
                
                let button = UIButton(type: .system)
                button.addTarget(for: .touchUpInside) { [weak self] in
                    if let unwrappedSelf = self, unwrappedSelf.dismissOnActionDidTouchUpInside {
                        unwrappedSelf.dismissVc()
                    }
                    anAction.action?(anAction)
                }
                
                button.setTitle(anAction.title, for: .normal)
                button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)
                self.stackViewButtonActions.addArrangedSubview(button)
            }
            
            self.stackViewButtons.addArrangedSubview(stackViewButtonActions)
            self.stackView.addArrangedSubview(self.stackViewButtons)
        }
        
        //cancel button
        if let cancelAction = cancelAction {
            let cancelButton = UIButton(type: .system)
            cancelButton.setTitle(cancelAction.title, for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cancelButton.addTarget(for: .touchUpInside) { [weak self] in
                if let unwrappedSelf = self, unwrappedSelf.dismissOnActionDidTouchUpInside {
                    unwrappedSelf.dismissVc()
                }
                cancelAction.action?(cancelAction)
            }
            
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            self.stackViewButtons.addArrangedSubview(cancelButton)
            
            // tap outside to dismiss
            let tapDismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVc))
            let dismissView = UIView(frame: self.view.bounds)
            dismissView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            dismissView.addGestureRecognizer(tapDismissGesture)
            self.view.insertSubview(dismissView, at: 0)
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
    
    @objc private func dismissVc() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - IBACTIONS
    
//    @objc private func pressDone(_ button: UIButton) {
//        self.pressDone(button: button)
//        self.dismiss()
//    }
//
//    @objc private func pressCancel(_ button: UIButton) {
//        self.dismiss()
//    }
    
    // MARK: - LIFE CYCLE
    
}
