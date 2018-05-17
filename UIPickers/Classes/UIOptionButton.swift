//
//  UIOptionButton.swift
//  UIPickers
//
//  Created by Erick Sanchez on 5/15/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit

@objc public protocol UIOptionButtonDelegate: class {
    @objc optional func optionButton(_ optionButton: UIOptionButton, didPressTitle button: UIButton)
    @objc optional func optionButton(_ optionButton: UIOptionButton, didPressClear button: UIButton)
}

public class UIOptionButton: UIView {
    
    public enum ButtonType {
        case TitleButtonAndClearAction
        case TitleButtonOnly
    }
    
    public weak var delegate: UIOptionButtonDelegate?
    
    public let type: ButtonType
    
    public var buttonTitle: String = "" {
        didSet {
            self.titleButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    public var isShowingClearButton: Bool {
        set {
            self.clearButton.isHidden = !newValue
        }
        get {
            return !self.clearButton.isHidden
        }
    }
    
    private lazy var titleButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(pressTitleButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        button.addTarget(self, action: #selector(pressClearButton(_:)), for: .touchUpInside)
        button.setTitle("x", for: .normal)
        
        return button
    }()
    
    public init(frame: CGRect = .zero, type: ButtonType) {
        self.type = type
        
        super.init(frame: frame)
        
        initLayout(with: type)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    private func initLayout(with type: ButtonType) {
        let horzStackView = UIStackView()
        horzStackView.translatesAutoresizingMaskIntoConstraints = false
        horzStackView.axis = .horizontal
        horzStackView.alignment = .fill
        horzStackView.distribution = .fill
        
        addSubview(horzStackView)
        horzStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        horzStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horzStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        horzStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        switch type {
        case .TitleButtonAndClearAction:
            horzStackView.addArrangedSubview(titleButton)
            horzStackView.addArrangedSubview(clearButton)
        case .TitleButtonOnly:
            horzStackView.addArrangedSubview(titleButton)
        }
        
        layoutIfNeeded()
    }
    
    // MARK: - IBACTIONS
    
    @objc private func pressTitleButton(_ button: UIButton) {
        delegate?.optionButton?(self, didPressTitle: button)
    }
    
    @objc private func pressClearButton(_ button: UIButton) {
        delegate?.optionButton?(self, didPressClear: button)
    }
    
    // MARK: - LIFE CYCLE
    
}
