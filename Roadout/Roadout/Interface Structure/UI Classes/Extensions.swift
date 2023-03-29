//
//  Extensions.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//
import Foundation
import UIKit
import CoreLocation

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
        
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done".localized(), style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        toolBar.tintColor = UIColor.Roadout.darkOrange//9
        self.inputAccessoryView = toolBar //10
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
    func rotateByRadians(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
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
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizables", bundle: .main, value: self, comment: self)
    }
    func formatLicensePlate() throws -> String {
        var plateText = self.replacingOccurrences(of: " ", with: "").uppercased()
        let plateNr = String(plateText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        guard var plateNrRange = plateText.range(of: plateNr) else { throw LicensePlateErrors.wrongFormat }
        plateText.insert("-", at: plateNrRange.lowerBound)
        plateNrRange = plateText.range(of: plateNr)!
        plateText.insert("-", at: plateNrRange.upperBound)
        
        return plateText
    }
}
extension UIControl {
    
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        if #available(iOS 14.0, *) {
            addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
        } else {
            @objc class ClosureSleeve: NSObject {
                let closure:()->()
                init(_ closure: @escaping()->()) { self.closure = closure }
                @objc func invoke() { closure() }
            }
            let sleeve = ClosureSleeve(closure)
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
            objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}
extension UICollectionView {
    
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension UIView {
    func setHeight(_ h:CGFloat, animateTime:TimeInterval?=nil) {
        
        if let c = self.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) {
            c.constant = CGFloat(h)
            
            if let animateTime = animateTime {
                UIView.animate(withDuration: animateTime, animations:{
                    self.superview?.layoutIfNeeded()
                })
            }
            else {
                self.superview?.layoutIfNeeded()
            }
        }
    }
}
extension UIView {
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func rotationAngleRadians() -> CGFloat {
        if #available(iOS 16.0, *) {
            return self.transform.decomposed().rotation
        }
        return CGFloat(atan2f(Float(self.transform.b), Float(self.transform.a)))
    }
}
extension UITableViewCell {
    var cellActionButtonLabel: UILabel? {
        superview?.subviews
            .filter { String(describing: $0).range(of: "UISwipeActionPullView") != nil }
            .flatMap { $0.subviews }
            .filter { String(describing: $0).range(of: "UISwipeActionStandardButton") != nil }
            .flatMap { $0.subviews }
            .compactMap { $0 as? UILabel }.first
    }
}
@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
