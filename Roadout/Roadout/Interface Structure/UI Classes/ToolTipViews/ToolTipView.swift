//
//  ToolTipView.swift
//  Roadout
//
//  Created by David Retegan on 30.06.2022.
//

import Foundation
import UIKit

fileprivate let TooltipLayerIdentifier: String = "toolTipID"
fileprivate let margin: CGFloat = 12

open class Tooltip: UIView {
    
    public enum Orientation {
        case top, bottom, left, right
    }
    
    private enum AdjustmentType {
        case left, right, top, bottom
    }
    
    public private(set) var contentView: UIView!
    
    public private(set) var presentingView: UIView?
    
    public private(set) var configuration: ToolTipConfiguration!
    
    public private(set) var orientation: Orientation = .top
    
    private var presentingViewFrame: CGRect {
        guard let presentingView = presentingView,
                let topVC = UIApplication.getTopViewController() else { return .zero }
        return presentingView.convert(presentingView.bounds, to: topVC.view)
    }
    
    private var adjustmentTypes: Set<AdjustmentType> = []
    
    private var originXValue: CGFloat {
        switch orientation {
        case .top, .bottom:
            return presentingViewFrame.midX
        case .right:
            return presentingViewFrame.maxX + configuration.offset
        case .left:
            return presentingViewFrame.minX - configuration.offset
        }
    }
    
    private var originYValue: CGFloat {
        switch orientation {
        case .top:
            return presentingViewFrame.minY - configuration.offset
        case .bottom:
            return presentingViewFrame.maxY + configuration.offset
        case .left, .right:
            return presentingViewFrame.midY
        }
    }
    
    private var remainingOrientations: [Orientation] = [.top, .bottom, .right, .left]
    
    private var nextOrientation: Orientation {
        
        var rndElement: Orientation {
            remainingOrientations.randomElement() ?? .top
        }
        
        switch orientation {
        case .top:
            remainingOrientations = remainingOrientations.remove(.top)
            return remainingOrientations.contains(.bottom) ? .bottom : rndElement
        case .bottom:
            remainingOrientations = remainingOrientations.remove(.bottom)
            return remainingOrientations.contains(.top) ? .top : rndElement
        case .left:
            remainingOrientations = remainingOrientations.remove(.left)
            return remainingOrientations.contains(.right) ? .right : rndElement
        case .right:
            remainingOrientations = remainingOrientations.remove(.right)
            return remainingOrientations.contains(.left) ? .left : rndElement
        }
    }
    
    private var hasVerticalOrientation: Bool {
        orientation == .top || orientation == .bottom
    }
    
    private var hasHorizontalOrientation: Bool {
        orientation == .left || orientation == .right
    }
    
    public convenience init(view: UIView, presentingView: UIView, orientation: Orientation, configuration: ((ToolTipConfiguration) -> ToolTipConfiguration)) {
        self.init(view: view, presentingView: presentingView, orientation: orientation)
        self.configuration = configuration(ToolTipConfiguration())
        
        setup()
    }
    
    public convenience init(view: UIView, presentingView: UIView, orientation: Orientation, configuration: ToolTipConfiguration = ToolTipConfiguration()) {
        self.init(view: view, presentingView: presentingView, orientation: orientation)
        self.configuration = configuration
        
        setup()
    }
    
    fileprivate init(view: UIView, presentingView: UIView, orientation: Orientation) {
        self.orientation = orientation
        self.contentView = view
        self.presentingView = presentingView
        
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use convenience initializers instead.")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        backgroundColor = configuration.backgroundColor
        
        // animate showing
        alpha = 0
        
        // If configured, handles automatic dismissal
        handleAutomaticDismissalIfNedded()
    }
    
    /// If the custom view contains a label that has no `preferredMaxLayoutWidth` set, it can happen that its width > screen size width.
    /// To prevent that artifically adjust the `preferredMaxLayoutWidth` to stay within bounds.
    private func adjustPreferredMaxLayoutWidthIfPossible() {
        let labels = contentView.subviews
            .compactMap { $0 as? UILabel }
        let filterLabels = labels.filter { $0.preferredMaxLayoutWidth == 0 ||
                $0.preferredMaxLayoutWidth > UIScreen.main.bounds.width - margin*2 ||
            $0.intrinsicContentSize.width > UIScreen.main.bounds.width - margin*2 }
        filterLabels.forEach {
            $0.preferredMaxLayoutWidth = UIScreen.main.bounds.width - margin*2
        }
    
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    /// Computes the original frame of the tooltip.
    private func computeFrame() {
        adjustPreferredMaxLayoutWidthIfPossible()
        
        let viewSize = contentView.boundsOrIntrinsicContentSize
        
        let origin: CGPoint
        switch orientation {
        case .top:
            // take tipsize into account
            origin = CGPoint(x: originXValue - viewSize.width/2, y: originYValue - viewSize.height)
        case .bottom:
            origin = CGPoint(x: originXValue - viewSize.width/2, y: originYValue)
        case .left:
            origin = CGPoint(x: originXValue - viewSize.width, y: originYValue - viewSize.height/2)
        case .right:
            origin = CGPoint(x: originXValue, y: originYValue - viewSize.height/2)
        }
        
        self.frame = validateRect(CGRect(x: origin.x, y: origin.y, width: viewSize.width, height: viewSize.height), adjustedX: origin.x, adjustedY: origin.y, orientation: orientation)
    }
    
    /// Validates the tooltip frame and updates frame and/or orientation if it's necessary.
    /// - Parameter rect: the rect that needs validation
    /// - Parameter adjustedX: the x coordinate of the rect's origin
    /// - Parameter adjustedY: the y coordinate of the rect's origin
    /// - Parameter orientation: The current orientation of the tooltip.
    private func validateRect(_ rect: CGRect, adjustedX: CGFloat, adjustedY: CGFloat, orientation: Orientation) -> CGRect {
        let screenBounds = UIScreen.main.bounds
        let globlSafeAreasInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            globlSafeAreasInsets = UIApplication.shared.keyWindow!.safeAreaInsets
        } else {
            // Fallback on earlier versions
            globlSafeAreasInsets = .zero
        }
        
        precondition(rect.width <= screenBounds.width - margin*2, warningMsg())
        precondition(rect.height <= screenBounds.height - margin*2 - globlSafeAreasInsets.top - globlSafeAreasInsets.bottom, warningMsg())
        
        switch orientation {
        case .top:
            if contentView.boundsOrIntrinsicContentSize.height + margin + globlSafeAreasInsets.top > presentingViewFrame.minY {
                self.orientation = nextOrientation(for: orientation)
            }
        case .bottom:
            if screenBounds.height - contentView.boundsOrIntrinsicContentSize.height - margin - globlSafeAreasInsets.bottom < presentingViewFrame.maxY {
                self.orientation = nextOrientation(for: orientation)
            }
            
        case .left:
            if contentView.boundsOrIntrinsicContentSize.width + margin + globlSafeAreasInsets.left > presentingViewFrame.minX {
                self.orientation = nextOrientation(for: orientation)
            }
        case .right:
            if screenBounds.width - contentView.boundsOrIntrinsicContentSize.width - margin - globlSafeAreasInsets.bottom <  presentingViewFrame.maxX {
                self.orientation = nextOrientation(for: orientation)
            }
        }
        
        if adjustedY < margin + globlSafeAreasInsets.top {
            adjustmentTypes.insert(.top)
            return validateRect(
                rect,
                adjustedX: adjustedX,
                adjustedY: margin + globlSafeAreasInsets.top,
                orientation: self.orientation
            )
        } else if adjustedY > screenBounds.height - margin - globlSafeAreasInsets.bottom {
            adjustmentTypes.insert(.bottom)
            return validateRect(
                rect,
                adjustedX: adjustedX,
                adjustedY: screenBounds.height - margin - globlSafeAreasInsets.bottom,
                orientation: self.orientation
            )
        } else if adjustedX < margin {
            adjustmentTypes.insert(.left)
            return validateRect(
                rect,
                adjustedX: margin,
                adjustedY: adjustedY,
                orientation: self.orientation
            )
        } else if adjustedX > screenBounds.width - margin - contentView.boundsOrIntrinsicContentSize.width {
            adjustmentTypes.insert(.right)
            return validateRect(
                rect,
                adjustedX: screenBounds.width - margin - contentView.boundsOrIntrinsicContentSize.width,
                adjustedY: adjustedY,
                orientation: self.orientation            )
        }
        return CGRect(origin: CGPoint(x: adjustedX, y: adjustedY), size: rect.size)
    }
    
    private var orientationsTried: Set<Orientation> = []
    private func nextOrientation(for prevOrientation: Orientation) -> Orientation {
        switch prevOrientation {
        case .top:
            orientationsTried.insert(.top)
            if !orientationsTried.contains(.bottom) { return .bottom }
            return .left
        case .bottom:
            orientationsTried.insert(.bottom)
            if !orientationsTried.contains(.top) { return .top }
            return .left
        case .left:
            orientationsTried.insert(.left)
            if !orientationsTried.contains(.right) { return .right }
            return .top
        case .right:
            orientationsTried.insert(.right)
            if !orientationsTried.contains(.left) { return .left }
            return .top
        }
    }
    
    private func handleAutomaticDismissalIfNedded() {
        guard configuration.dismissAutomatically else { return }
        Timer.scheduledTimer(withTimeInterval: configuration.timeToDimiss, repeats: false, block: { [weak self] _ in
            self?.dismiss()
        })
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()
        
        computeFrame()
        drawToolTip()
    }
    
    /*
     Draws the rect of the tooltip
     */
    private func drawToolTip() {
        // remove previously added layers to prevent double drawing
        self.layer.sublayers?.removeAll(where: { $0.name == TooltipLayerIdentifier })
        let rect = self.bounds
        let inset = configuration.inset
        let roundRect = CGRect(x: rect.minX - inset, y: rect.minY - inset, width: rect.width + inset * 2, height: rect.height + inset * 2)
        let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 16.0)
        
        if configuration.showTip {
            let trianglePath = drawTip()
            roundRectBez.append(trianglePath)
        }
        roundRectBez.lineWidth = 2
        
        let shape = createShapeLayer(roundRectBez.cgPath)
        self.layer.insertSublayer(shape, at: 0)
    }
    
    /*
     Draws the tip of the tooltip fitting the specified orientation
     */
    private func drawTip() -> UIBezierPath {
        let tipPath = UIBezierPath()
        let tipSize = configuration.tipSize
        let inset = configuration.inset
        let rect = self.bounds
        
        let convertedPresentingFrame = presentingView!.convert(presentingView!.bounds, to: self)
        
        var xValueCenter: CGFloat = rect.midX
        var yValueCenter: CGFloat = rect.midY
        
        switch orientation {
        case .top, .bottom:
            xValueCenter = rect.midX
        case .left, .right:
            xValueCenter = rect.minY
        }
        
        for adjustmentType in adjustmentTypes {
            if (adjustmentType == .right || adjustmentType == .left) && hasVerticalOrientation {
                xValueCenter = convertedPresentingFrame.midX
            }
            
            if (adjustmentType == .top || adjustmentType == .bottom) && hasHorizontalOrientation {
                yValueCenter = convertedPresentingFrame.midY
            }
        }
        
        switch orientation {
        case .top:
            tipPath.move(to: CGPoint(x: xValueCenter - tipSize.width/2, y: rect.maxY + inset ))
            tipPath.addLine(to: CGPoint(x: xValueCenter + tipSize.width/2, y: rect.maxY + inset ))
            tipPath.addLine(to: CGPoint(x: xValueCenter, y: rect.maxY + tipSize.height ))
            tipPath.addLine(to: CGPoint(x: xValueCenter - tipSize.width/2, y: rect.maxY + inset ))
        case .bottom:
            tipPath.move(to: CGPoint(x: xValueCenter - tipSize.width/2, y: rect.minY - inset))
            tipPath.addLine(to: CGPoint(x: xValueCenter + tipSize.width/2, y: rect.minY - inset))
            tipPath.addLine(to: CGPoint(x: xValueCenter, y: rect.minY - tipSize.height ))
            tipPath.addLine(to: CGPoint(x: xValueCenter - tipSize.width/2, y: rect.minY - inset))
        case .left:
            tipPath.move(to: CGPoint(x: rect.maxX + inset, y: yValueCenter - tipSize.height/2 ))
            tipPath.addLine(to: CGPoint(x: rect.maxX + inset, y: yValueCenter + tipSize.height/2 ))
            tipPath.addLine(to: CGPoint(x: rect.maxX + tipSize.height, y: yValueCenter ))
            tipPath.addLine(to: CGPoint(x: rect.maxX + inset, y: yValueCenter - tipSize.height/2 ))
        case .right:
            tipPath.move(to: CGPoint(x: rect.minX - inset, y: yValueCenter - tipSize.height/2 ))
            tipPath.addLine(to: CGPoint(x: rect.minX - inset, y: yValueCenter + tipSize.height/2 ))
            tipPath.addLine(to: CGPoint(x: rect.minX - tipSize.height, y: yValueCenter ))
            tipPath.addLine(to: CGPoint(x: rect.minX - inset, y: yValueCenter - tipSize.height/2 ))
        }
        
        tipPath.close()
        return tipPath
    }
    
    func createShapeLayer(_ path : CGPath) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = configuration.backgroundColor.cgColor
        shape.shadowColor = configuration.shadowConfiguration.shadowColor
        shape.shadowOffset = configuration.shadowConfiguration.shadowOffset
        shape.shadowRadius = configuration.cornerRadius
        shape.shadowOpacity = configuration.shadowConfiguration.shadowOpacity
        shape.name = TooltipLayerIdentifier
        return shape
    }
    
    /// Dismisses the tooltip.
    open func dismiss() {
        UIView.animate(
            withDuration: configuration.animationConfiguration.animationDuration,
            delay: configuration.animationConfiguration.animationDelay,
            options: configuration.animationConfiguration.animationOptions,
            animations: { [weak self] in
                self?.alpha = 0
                self?.configuration.onDismiss?()
            },
            completion: { [weak self] _ in
                self?.isHidden = true
                self?.removeFromSuperview()
            }
        )
    }
    
    /// Presents the tooltip.
    open func present() {
        UIView.animate(
            withDuration: configuration.animationConfiguration.animationDuration,
            delay: configuration.animationConfiguration.animationDelay,
            options: configuration.animationConfiguration.animationOptions,
            animations: { [unowned self] in
                self.configuration.onPresent?()
                self.alpha = 1
            }
        )
    }
    
    private func warningMsg() -> String {
        """
            LAYOUT WARNING:
        
            It seems that the view displayed as a tooltip is too large!
            Please make sure that size of the tooltip is valid and try again.
        """
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if !self.bounds.contains(point) {
            dismiss()
            return false
        }
        return true
    }
}

//MARK: -Configuration-

public extension Tooltip {
    /// `TooltipConfiguration` allows to customize a `Tooltip` according to the user's preferences.
    class ToolTipConfiguration {
        /// Specifies whether the tip is be shown.
        public var showTip: Bool = true
        /// The background color of the `Tooltip` object. Defaults to `.darkGray`.
        public var backgroundColor: UIColor = .darkGray
        /// The offset of the tooltip to the view it belongs to. Defaults to `20`.
        public var offset: CGFloat = 20
        /// The inset of the tooltip's content to the tooltip's edges. Defaults to `10`.
        public var inset: CGFloat = 10
        /// The size of the tip that points towards to the view that is displaying the tooltip. Defaults to `CGSize(width: 20, height: 20)`
        public var tipSize: CGSize = CGSize(width: 20, height: 20)
        /// The corner radius of the tooltip. Defaults to `5.0`
        public var cornerRadius: CGFloat = 16.0
        /// The configuration for the displaying and dismiss animations of the tooltip. Refer to `AnimationConfiguration` for default settings.
        public var animationConfiguration: AnimationConfiguration = AnimationConfiguration()
        /// The configuration for the shadow properties of the tooltip. Refer to `ShadowConfiguration` for default settings.
        public var shadowConfiguration: ShadowConfiguration = ShadowConfiguration()
        /// The configuration for the tooltip if it is displayed by calling `tooltip(_ text: String, ...)`. Refer to `LabelConfiguration` for default settings.
        public var labelConfiguration: LabelConfiguration = LabelConfiguration()
        /// Boolean value indicating if the tooltip is automatically dismissed after `timeToDimiss` time interval. Defaults to `false`
        public var dismissAutomatically: Bool = false
        /// If `dismissAutomatically`is set to true, this can be used to set the time interval after which the tooltip is dismissed. Defaults to `2.5` seconds.
        public var timeToDimiss: TimeInterval = 2.5
        /// Optional Callback that is executed when the tooltip is dismissed.
        public var onDismiss: (() -> Void)? = nil
        /// Optional Callback that is executed when the tooltip is shown.
        public var onPresent: (() -> Void)? = nil
        /// Default init.
        public init() {}
    }
    
    /// `ShadowConfiguration` contains properties that allow to customize the shadow properties of the tooltip.
    class ShadowConfiguration {
        /// The color of th shadow. Defaults to `UIColor.black.withAlphaComponent(0.60).cgColor`.
        public var shadowColor: CGColor = UIColor.black.withAlphaComponent(0.60).cgColor
        /// The offset of the shadow to the tooltip. Defaults to `CGSize(width: 0, height: 2)`.
        public var shadowOffset: CGSize = CGSize(width: 0, height: 2)
        /// The opacity of the shadow. Defaults to `0.8`.
        public var shadowOpacity: Float = 0.8
    }
    
    /// `AnimationConfiguration` contains properties that allow to customize the displaying and dismiss animations of the tooltip.
    class AnimationConfiguration {
        /// The duration of the animation. Defaults to `0.25`.
        public var animationDuration: CGFloat = 0.25
        /// The delay of the animation. Defaults to zero.
        public var animationDelay: CGFloat = 0.0
        /// Additional `UIView.AnimationOptions` to further customize the animation. `.curveEaseOut` is set as default.
        public var animationOptions: UIView.AnimationOptions = [.curveEaseOut]
    }
    
    /// **NOTE**: Only needed if tooltip is displayed via `tooltip(_ text: String,...)`.
    /// `LabelConfiguration` contains properties that allow to customize the label that is used to display the string.
    class LabelConfiguration {
        /// The text alignment. Defaults to `.center`.
        public var textAlignment: NSTextAlignment = .center
        /// The text color. Defaults to `.white`.
        public var textColor: UIColor = .white
        /// The text font. Defaults to `.systemFont(ofSize: 14, weight: .medium)`
        public var font: UIFont = .systemFont(ofSize: 14, weight: .medium)
        /// The max length of the label and therefore the tooltip. Indicates at which point a linebreak is performed. Defaults to 150
        public var preferredMaxLayoutWidth: CGFloat = 150
    }
}


