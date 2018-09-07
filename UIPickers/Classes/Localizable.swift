//
//  Localizable.swift
//  Assigned
//
//  Created by Erick Sanchez on 6/30/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import Foundation

/** extend this enum to add static lets to get to the localized value inside controllers */
class LocalizeUtlitity {
//    static let Feedback = String(localized: "WDs: Feedback")
//    static let Nevermind = String(localized: "WDs: Nevermind")
//    static let Unplanned = String(localized: "WDs: Unplanned")
//    static let Planned = String(localized: "WDs: Planned")
//    static let Notes = String(localized: "WDs: Notes")
//    static let Done = String(localized: "WDs: Done")
//    static let Today = String(localized: "WDs: Today")
//    static let Plan = String(localized: "WDs: Plan")
//    static let NoDeadline = String(localized: "WDs: No Deadline")
//    static let Tomorrow = String(localized: "WDs: Tomorrow")
//    static let Yesterday = String(localized: "WDs: Yesterday")
//    static let ago = String(localized: "WDs: ago")
//    static let Cancel = String(localized: "WDs: Cancel")
//    static let Dismiss = String(localized: "WDs: Dismiss")
    
}

extension String {
    init(localized key: String, default: String! = nil, comment: String) {
//        guard
//            let bundlePath = Bundle.main.path(forResource: "UIPickers", ofType: "bundle"),
//            let bundle = Bundle(path: bundlePath) else {
//                assertionFailure("failed to load bundle")
//
//                self = ""
//
//                return
//        }
        
        let bu = Bundle(for: LocalizeUtlitity.self)
        
        if let defaultValue = `default` {
            self = NSLocalizedString(key, tableName: nil, bundle: bu, value: defaultValue, comment: "")
        } else {
            self = NSLocalizedString(key, tableName: nil, bundle: bu, value: "", comment: "")
        }
    }
}
//
//import UIKit.UILabel
//extension UILabel {
//    @IBInspectable var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            if let key = key {
//                text = String(localized: key)
//            }
//        }
//    }
//}
//
//import UIKit.UIButton
//extension UIButton {
//    @IBInspectable var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            if let key = key {
//                setTitle(String(localized: key), for: .normal)
//            }
//        }
//    }
//}
//
//import UIKit.UITextField
//extension UITextField {
//    @IBInspectable var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            if let key = key {
//                placeholder = String(localized: key)
//            }
//        }
//    }
//}
//
//import UIKit.UINavigationItem
//extension UINavigationItem {
//    @IBInspectable var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            if let key = key {
//                title = String(localized: key)
//            }
//        }
//    }
//}
//
//import UIKit.UIBarButtonItem
//extension UIBarButtonItem {
//    @IBInspectable var xibLocKey: String? {
//        get { return nil }
//        set(key) {
//            if let key = key {
//                title = String(localized: key)
//            }
//        }
//    }
//}
//
//extension UIValidatedTextField {
//    @IBInspectable var defaultTextLocKey: String? {
//        get { return nil }
//        set(key) {
//            if let key = key {
//                defaultText = String(localized: key)
//            }
//        }
//    }
//}
