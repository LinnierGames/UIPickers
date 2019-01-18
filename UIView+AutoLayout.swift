//
//  UIView+AutoLayout.swift
//  FBSnapshotTestCase
//
//  Created by Erick Sanchez on 1/18/19.
//

import UIKit

extension UIView {
    
    // translatesAutoresizingMaskIntoConstraints
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
}
