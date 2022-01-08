//
//  Extensions.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//
import Foundation
import UIKit

extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)

        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
}
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = String(t!.prefix(maxLength))
    }
}
extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = MonthYearPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        //datePicker.datePickerMode = .date
        
        // iOS 14 and above
        /*if #available(iOS 14, *) {// Added condition for iOS 14
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }*/
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        } else {
         return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
}
extension UILabel {

    public var fullRange: NSRange { return NSMakeRange(0, text?.count ?? 0) }

    public func range(string: String) -> NSRange? {
        let range = NSString(string: forceText).range(of: string)
        return range.location != NSNotFound ? range : nil
    }

    public func range(after string: String) -> NSRange? {
        guard var range = range(string: string) else { return nil }
        range.location = range.location + range.length
        range.length = forceText.count - range.location
        return range
    }

    public func range(before string: String) -> NSRange? {
        guard var range = range(string: string) else { return nil }
        range.length = range.location
        range.location = 0
        return range
    }

    public func range(after: String, before: String) -> NSRange? {
        guard let rAfter = range(after: after),
            let rBefore = range(before: before),
            rAfter.location < rBefore.length
            else { return nil }
        return NSMakeRange(rAfter.location, rBefore.length - rAfter.location)
    }

    public func range(fromBeginningOf string: String) -> NSRange? {
        guard var range = range(string: string) else { return nil }

        range.length = forceText.count - range.location
        return range
    }

    public func range(untilEndOf string: String) -> NSRange? {
        guard var range = range(string: string) else { return nil }
        range.length = range.location + range.length
        range.location = 0
        return range
    }

    public func range(fromBeginningOf beginString: String, untilEndOf endString: String) -> NSRange? {
        guard let rBegin = range(fromBeginningOf: beginString),
            let rEnd = range(untilEndOf: endString),
            rBegin.location < rEnd.length
            else { return nil }
        return NSMakeRange(rBegin.location, rEnd.length - rBegin.location)
    }

    // MARK: Range Formatter
    public func set(textColor: UIColor, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString
        text.addAttribute(.foregroundColor, value: textColor, range: range)
        attributedText = text
    }

    public func set(font: UIFont, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString
        text.addAttribute(.font, value: font, range: range)
        attributedText = text
    }

    public func set(underlineColor: UIColor, range: NSRange?, byWord: Bool = false) {
        guard let range = range else { return }
        let text = mutableAttributedString
        var style = NSUnderlineStyle.single.rawValue
        if byWord { style = style | NSUnderlineStyle.byWord.rawValue }
        text.addAttribute(.underlineStyle, value: NSNumber(value: style), range: range)
        text.addAttribute(.underlineColor, value: underlineColor, range: range)
        attributedText = text
    }

    public func setTextWithoutUnderline(_ range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString
        text.removeAttribute(.underlineStyle, range: range)
        attributedText = text
    }

    // MARK: Helpers
    private var forceText: String { return text ?? "" }

    private var mutableAttributedString: NSMutableAttributedString {
        if let attr = attributedText {
            return NSMutableAttributedString(attributedString: attr)
        } else {
            return NSMutableAttributedString(string: forceText)
        }
    }
}
extension UIView {
    //Get Parent View Controller from any view
    func parentViewController() -> UIViewController {
        var responder: UIResponder? = self
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }
}
extension UIImage {
    func withResize(scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    func fadeIn() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    func fadeOut() {
       UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
           self.alpha = 0.0
           }, completion: nil)
   }
}
