//
//  UIView+AutoLayout.swift
//  FBSnapshotTestCase
//
//  Created by Erick Sanchez on 1/18/19.
//

import UIKit

extension UIView {
    
    // MARK: translatesAutoresizingMaskIntoConstraints
    
    static func initProgrammatically() -> Self {
        let view = self.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    static func initProgrammatically(frame: CGRect) -> Self {
        let view = self.init(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    static func initProgrammatically<T: UIView>(from closure: () -> T) -> T {
        let view = closure()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    func addSubviewsProgrammatically(_ views: UIView ...) {
        for aView in views {
            aView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(aView)
        }
    }
    
    // MARK: updating the content resistance priority
    
    /**
     if invoked, content resistance priority is set to required vertially
     */
    func cannotCompressInContentView() {
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    /**
     if invoked, content resistance priority is set to default hight, or 750, vertially
     */
    func canCompressInContentView() {
        self.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}
