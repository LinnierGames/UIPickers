//
//  UniversalExtentions.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/26/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation
import UIKit

struct IfError {
    @discardableResult
    init?(_ error: Error?) {
        if let err = error {
            assertionFailure(err.localizedDescription)
            return nil
        }
    }
    
    @discardableResult
    init?(_ error: Error?, handler: (Error) -> Void) {
        if let err = error {
            assertionFailure(err.localizedDescription)
            handler(err)
            return nil
        }
    }
}

@objc enum CRUD: Int {
    case Create
    case Read
    case Update
    case Delete
    
    var isCreating: Bool {
        return self == .Create
    }
    
    var isReading: Bool {
        return self == .Read
    }
    
    var isUpdating: Bool {
        return self == .Update
    }
    
    var isDeleting: Bool {
        return self == .Delete
    }
}

enum CopyOptions<T> {
    case All
    case Some([T])
    case None
}

extension SignedInteger {
    var isEven: Bool {
        return self % 2 == 0
    }
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    class var lighterGray: UIColor {
        return UIColor(white: 0.98, alpha: 1)
    }
    
    @available(iOS 10.0, *)
    class var disabledGray: UIColor {
        return UIColor(displayP3Red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    }
    
    @available(iOS 10.0, *)
    class var destructive: UIColor {
        return UIColor(displayP3Red: 255/255, green: 56.0/255.0, blue: 36.0/255.0, alpha: 1)
    }
    
    //FIXME: store the empty view? or create it every time this property is read
    static var buttonTint: UIColor = {
        let view = UIView()
        
        return view.tintColor
    }()
    
    class var lowLightTransparency: UIColor {
        return UIColor(white: 1.0, alpha: 0.85)
    }
    
    class var highLightTransparency: UIColor {
        return UIColor(white: 1.0, alpha: 0.35)
    }
    
    class var lowDarkTransparency: UIColor {
        return UIColor(white: 0.0, alpha: 0.75)
    }
    
    class var highDarkTransparency: UIColor {
        return UIColor(white: 0.0, alpha: 0.35)
    }
}

extension NSSortDescriptor {
    static func localizedStandardCompare(with key: String, ascending: Bool = false) -> NSSortDescriptor {
        return NSSortDescriptor(key: key, ascending: ascending, selector: #selector(NSString.localizedStandardCompare(_:)))
    }
}

extension NSAttributedString {
    
    /**
     Create an attributed string based on the given query. Any characters in the
     given string will have the given attributes applied
     
     - parameter query: <#Consectetur adipisicing elit.#>
     
     - parameter attributes: <#Consectetur adipisicing elit.#>
     */
    convenience init(string: String, for query: (Character) -> (Bool), with attributes: [NSAttributedStringKey : Any]) {
        let attributed = NSMutableAttributedString(string: string)
        
        func addAttribute(_ startingIndex: inout Int?, _ index: Int, _ attributed: NSMutableAttributedString, _ attributes: [NSAttributedStringKey : Any]) {
            if let lowerBound = startingIndex {
                let range = NSRange(location: lowerBound, length: index - lowerBound + 1)
                #if swift(>=4.0)
                attributed.addAttributes(attributes, range: range)
                #else
                attributed.addAttributes(attributes as [String : Any], range: range)
                #endif
                startingIndex = nil
            }
        }
        
        var startingIndex: Int? = nil
        let lastIndex = string.count - 1
        for (index, aChar) in string.enumerated() {
            if query(aChar) {
                if startingIndex == nil {
                    startingIndex = index
                }
            } else {
                addAttribute(&startingIndex, index - 1, attributed, attributes)
            }
            
            if index == lastIndex {
                addAttribute(&startingIndex, index, attributed, attributes)
            }
        }
        
        self.init(attributedString: attributed)
    }
}

extension NSMutableAttributedString {
    convenience init(strikedOut string: String) {
        self.init(string: string)
        #if swift(>=4.0)
            self.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, string.count))
        #else
            self.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, string.count))
        #endif
    }
}

extension String {
    init?(doubledCurrency value: Double) {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let string = formatter.string(from: NSNumber(value: value)) {
            self = string
        } else {
            return nil
        }
    }
    
    var rangeOfCharacters: NSRange {
        return NSRange(location: 0, length: self.count)
    }
}

extension UITableView {
    func headerLabel(forSection section: Int) -> UILabel? {
        return self.headerView(forSection: section)?.contentView.subviews.first as! UILabel?
    }
    func footerLabel(forSection section: Int) -> UILabel? {
        return self.footerView(forSection: section)?.contentView.subviews.first as! UILabel?
    }
}

extension UITextField {
    
    /**
     set the textfield's auto correction type to default and auto capitalization
     type to words and update the text and placeholder text
     */
    open func setStyleToParagraph(withPlaceholderText placeholder: String? = "", withInitalText text: String? = "") {
        self.autocorrectionType = .default
        self.autocapitalizationType = .words
        self.text = text
        self.placeholder = placeholder
        
    }
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     
     - parameter <#bar#>: <#Consectetur adipisicing elit.#>
     
     - returns: <#Sed do eiusmod tempor.#>
     */
    func isEmpty() -> Bool {
        return self.text != "" && self.text != nil
    }
    
}

@available( *, deprecated)
public struct UIAlertActionInfo {
    var title: String?
    var style: UIAlertActionStyle
    var handler: ((UIAlertAction) -> Swift.Void)?
    
    init(title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Swift.Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension UIAlertController {
    @available( *, deprecated)
    open func addActions(cancelButton cancel: String? = "Cancel", actions: UIAlertActionInfo...) {
        for action in actions {
            self.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.handler))
        }
        if cancel != nil {
            self.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        }
    }
    
    /**
     Adds a button with, or without an action closure with the given title
     
     - warning: the button's style is set to .default
     
     - returns: UIAlertController
     */
    public func addDismissButton(title: String = "Dismiss") -> UIAlertController {
        return self.addButton(title: title, with: { _ in })
    }
    
    /**
     Add a button with a title, style, and action.
     
     - warning: style and action defaults to .default and an empty closure body
     
     - returns: UIAlertController
     */
    public func addButton(title: String, style: UIAlertActionStyle = .default, with action: @escaping (UIAlertAction) -> () = {_ in}) -> UIAlertController {
        self.addAction(UIAlertAction(title: title, style: style, handler: action))
        
        return self
    }
    
    /**
     Add a textfield with the given text and placeholder text
     
     - warning: the newly added textfield invokes .setStyleToParagraph(..)
     
     - returns: UIAlertController
     */
    public func addTextField(defaultText: String? = nil, placeholderText: String? = nil) -> UIAlertController {
        self.addTextField(configurationHandler: { (textField) in
            textField.setStyleToParagraph(withPlaceholderText: placeholderText, withInitalText: defaultText)
        })
        
        return self
    }
    
    /**
     Add a button with the style set to .cancel.
     
     the default action is an empty closure body
     
     - returns: UIAlertController
     */
    public func addCancelButton(title: String = "Cancel", with action: @escaping (UIAlertAction) -> () = {_ in}) -> UIAlertController {
        return self.addButton(title: title, style: .cancel, with: action)
    }
    
    /**
     Adds a button with a cancel button after it
     
     - warning: cancel button's action is an empty closure
     
     - returns: UIAlertController
     */
    public func addConfirmationButton(title: String, style: UIAlertActionStyle = .default, with action: @escaping (UIAlertAction) -> ()) -> UIAlertController {
        return
            self.addButton(title: title, style: style, with: action)
            .addCancelButton()
    }
    
    /**
     For the given viewController, present(..) invokes viewController.present(..)
     
     - warning: viewController.present(.., animiated: true, ..doc)
     
     - returns: Discardable UIAlertController
     */
    @discardableResult
    public func present(in viewController: UIViewController, completion: (() -> ())? = nil) -> UIAlertController {
        viewController.present(self, animated: true, completion: completion)
        
        return self
    }
    
    var inputField: UITextField {
        return self.textFields!.first!
    }
}

typealias UITextAlertController = UIAlertController

extension UITextAlertController {
    @available( *, deprecated, message: "use the nomad addTextField(..)")
    convenience init(title: String?, message: String?, textFieldConfig: ((UITextField) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: .alert)
        
        self.addTextField(configurationHandler: textFieldConfig ?? { $0.setStyleToParagraph() })
    }
    
    /** this will insert a cancel action after the action */
    @available( *, deprecated)
    open func addConfirmAction(action: UIAlertActionInfo) {
        self.addActions(cancelButton: nil, actions: action)
        self.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
}

extension Bool {
    public mutating func invert() {
        if self == true {
            self = false
        } else {
            self = true
        }
    }
    
    public var inverse: Bool {
        if self == true {
            return false
        } else {
            return true
        }
    }
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    static let SettingViewDidAppear = "settings.viewDidAppear"
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

extension UIButton {
    func setTitleWithoutAnimation(_ title: String?, for state: UIControlState) {
        UIView.performWithoutAnimation {
            self.setTitle(title, for: state)
            self.layoutIfNeeded()
        }
    }
}

extension CALayer {
    func clear() {
        self.backgroundColor = nil
        self.cornerRadius = 0.0
        
        self.borderColor = nil
        self.borderWidth = 0.0
        
        self.shadowColor = nil
        self.shadowOffset = CGSize.zero
        self.shadowRadius = 0.0
    }
    
    func roundedOutline(
        cornerRadius: CGFloat = 4.0,
        borderColor: UIColor = UIColor.buttonTint,
        borderWidth: CGFloat = 1.0
        ) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor.cgColor
    }
    
    func roundedShape(
        cornerRadius: CGFloat = 0.0,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0.0,
        backgroundColor: UIColor? = nil
        ) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor?.cgColor
        self.backgroundColor = backgroundColor?.cgColor
    }
}

fileprivate class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addTarget(for controlEvents: UIControlEvents, action closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIViewController {
    var isUserInteractionEnabled: Bool {
        set {
            self.view.isUserInteractionEnabled = newValue
        }
        get {
            return self.view.isUserInteractionEnabled
        }
    }
}

@available(iOS 10.0, *)
extension UIViewPropertyAnimator {
    
    @available(*, deprecated)
    static let transitionAnimationDuration = 0.45
}

extension TimeInterval {
    static let transitionAnimationDuration: TimeInterval = 0.45
    static let transitionImmediatelyAnimationDuration: TimeInterval = 0.15
}

extension UIApplication {
    
    /**
     When you open the URL built from this string, the system launches the Settings app and displays the app’s custom settings, if it has an
     */
    @available(iOS 10.0, *)
    func openAppSettings(options: [String : Any] = [:], completion: ((Bool) -> ())? = nil) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
        self.open(openSettingsUrl, options: options, completionHandler: completion)
    }
}

extension CGPoint {
    static func +(lo: CGPoint, ro: CGPoint) -> CGPoint {
        return CGPoint(x: lo.x + ro.x, y: lo.y + ro.y)
    }
    
    static func -(lo: CGPoint, ro: CGPoint) -> CGPoint {
        return CGPoint(x: lo.x - ro.x, y: lo.y - ro.y)
    }
}

extension UINavigationBar {
    
    //TODO: blury navigation item
    
    /**
     <#Lorem ipsum dolor sit amet.#>
     
     - warning: self.barTintColor will be set to UIColor.clear. If you don't want
     this, update the tint color after invoking this message
     */
    func hideBottomShadow(/*with backgroundColor: UIColor = UIColor.clear*/) {
//        self.barTintColor = backgroundColor
//        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
}

extension UIViewController {
    
    var safeAreaInsets: UIEdgeInsets {
        var topSafeArea = CGFloat()
        var bottomSafeArea = CGFloat()
        
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
        
        return UIEdgeInsets(top: topSafeArea, left: 0, bottom: bottomSafeArea, right: 0)
    }
}

public enum Model : String {
    case simulator   = "simulator/sandbox",
    iPod1            = "iPod 1",
    iPod2            = "iPod 2",
    iPod3            = "iPod 3",
    iPod4            = "iPod 4",
    iPod5            = "iPod 5",
    iPad2            = "iPad 2",
    iPad3            = "iPad 3",
    iPad4            = "iPad 4",
    iPhone4          = "iPhone 4",
    iPhone4S         = "iPhone 4S",
    iPhone5          = "iPhone 5",
    iPhone5S         = "iPhone 5S",
    iPhone5C         = "iPhone 5C",
    iPadMini1        = "iPad Mini 1",
    iPadMini2        = "iPad Mini 2",
    iPadMini3        = "iPad Mini 3",
    iPadAir1         = "iPad Air 1",
    iPadAir2         = "iPad Air 2",
    iPadPro9_7       = "iPad Pro 9.7\"",
    iPadPro9_7_cell  = "iPad Pro 9.7\" cellular",
    iPadPro10_5      = "iPad Pro 10.5\"",
    iPadPro10_5_cell = "iPad Pro 10.5\" cellular",
    iPadPro12_9      = "iPad Pro 12.9\"",
    iPadPro12_9_cell = "iPad Pro 12.9\" cellular",
    iPhone6          = "iPhone 6",
    iPhone6plus      = "iPhone 6 Plus",
    iPhone6S         = "iPhone 6S",
    iPhone6Splus     = "iPhone 6S Plus",
    iPhoneSE         = "iPhone SE",
    iPhone7          = "iPhone 7",
    iPhone7plus      = "iPhone 7 Plus",
    iPhone8          = "iPhone 8",
    iPhone8plus      = "iPhone 8 Plus",
    iPhoneX          = "iPhone X",
    unrecognized     = "?unrecognized?"
}

public extension UIDevice {
    public var modelType: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"       : .simulator,
            "x86_64"     : .simulator,
            "iPod1,1"    : .iPod1,
            "iPod2,1"    : .iPod2,
            "iPod3,1"    : .iPod3,
            "iPod4,1"    : .iPod4,
            "iPod5,1"    : .iPod5,
            "iPad2,1"    : .iPad2,
            "iPad2,2"    : .iPad2,
            "iPad2,3"    : .iPad2,
            "iPad2,4"    : .iPad2,
            "iPad2,5"    : .iPadMini1,
            "iPad2,6"    : .iPadMini1,
            "iPad2,7"    : .iPadMini1,
            "iPhone3,1"  : .iPhone4,
            "iPhone3,2"  : .iPhone4,
            "iPhone3,3"  : .iPhone4,
            "iPhone4,1"  : .iPhone4S,
            "iPhone5,1"  : .iPhone5,
            "iPhone5,2"  : .iPhone5,
            "iPhone5,3"  : .iPhone5C,
            "iPhone5,4"  : .iPhone5C,
            "iPad3,1"    : .iPad3,
            "iPad3,2"    : .iPad3,
            "iPad3,3"    : .iPad3,
            "iPad3,4"    : .iPad4,
            "iPad3,5"    : .iPad4,
            "iPad3,6"    : .iPad4,
            "iPhone6,1"  : .iPhone5S,
            "iPhone6,2"  : .iPhone5S,
            "iPad4,1"    : .iPadAir1,
            "iPad4,2"    : .iPadAir2,
            "iPad4,4"    : .iPadMini2,
            "iPad4,5"    : .iPadMini2,
            "iPad4,6"    : .iPadMini2,
            "iPad4,7"    : .iPadMini3,
            "iPad4,8"    : .iPadMini3,
            "iPad4,9"    : .iPadMini3,
            "iPad6,3"    : .iPadPro9_7,
            "iPad6,11"   : .iPadPro9_7,
            "iPad6,4"    : .iPadPro9_7_cell,
            "iPad6,12"   : .iPadPro9_7_cell,
            "iPad6,7"    : .iPadPro12_9,
            "iPad6,8"    : .iPadPro12_9_cell,
            "iPad7,3"    : .iPadPro10_5,
            "iPad7,4"    : .iPadPro10_5_cell,
            "iPhone7,1"  : .iPhone6plus,
            "iPhone7,2"  : .iPhone6,
            "iPhone8,1"  : .iPhone6S,
            "iPhone8,2"  : .iPhone6Splus,
            "iPhone8,4"  : .iPhoneSE,
            "iPhone9,1"  : .iPhone7,
            "iPhone9,2"  : .iPhone7plus,
            "iPhone9,3"  : .iPhone7,
            "iPhone9,4"  : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            return model
        }
        
        return Model.unrecognized
    }
}

// MARK: Core Data

extension NSPredicate {
    
    convenience init(date: Date, forKey key: String = "date") {
        let midnight = date.midnight
        let endOfDay = date.endOfDay
        
        self.init(format: "(%@ <= %K) AND (%K < %@)", midnight as NSDate, key, key, endOfDay as NSDate)
    }
    
    func appending(predicate otherPredicate: NSPredicate, byLogical operator: NSCompoundPredicate.LogicalType = .and) -> NSCompoundPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, otherPredicate])
    }
}
