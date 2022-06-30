//
//  ToolTipViewExtensions.swift
//  Roadout
//
//  Created by David Retegan on 30.06.2022.
//

import Foundation
import UIKit

internal extension UIApplication {
    static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

internal extension Array where Element: Equatable {
    func remove(_ element: Element) -> Self {
        var mutableCopy = self
        for (index, ele) in mutableCopy.enumerated() {
            if ele == element {
                mutableCopy.remove(at: index)
                
            }
        }
        return mutableCopy
    }
}

extension UIView {
    internal var boundsOrIntrinsicContentSize: CGSize {
        return self.bounds.size != .zero ? self.bounds.size : self.intrinsicContentSize
    }
    
    /// Returns true, if the calling UIView has an active tooltip.
    /// True if there is currently a tooltip presented that has the calling view as `presentingView`.
    public var hasActiveTooltip: Bool {
        guard let activeTooltips = UIApplication.shared.keyWindow?.subviews.filter({ $0 is Tooltip }),
              !activeTooltips.isEmpty else { return false }
        
        return activeTooltips.compactMap { $0 as? Tooltip }.contains(where: { $0.presentingView == self })
    }
    
    /// Presents a tooltip to the calling view with a given view, orientation and configuration.
    ///
    /// - Parameter view    :The view that will be displayed within the tooltip
    /// - Parameter orientation: The placement of the tooltip in relation to the presenting view
    /// - Parameter configuration: The configuration allowing to customize the tooltip
    public func tooltip(_ view: UIView, orientation: Tooltip.Orientation, configuration: Tooltip.ToolTipConfiguration = Tooltip.ToolTipConfiguration()) {
        guard !hasActiveTooltip else { return }
        let toolTip = Tooltip(view: view, presentingView: self, orientation: orientation, configuration: configuration)
        
        UIApplication.shared.keyWindow?.addSubview(toolTip)
        toolTip.present()
    }
    
    /// Presents a tooltip to the calling view with a given text, orientation and configuration.
    ///
    /// - Parameter text    :The text that will be displayed within the tooltip
    /// - Parameter orientation: The placement of the tooltip in relation to the presenting view
    /// - Parameter configuration: The configuration allowing to customize the tooltip
    public func tooltip(_ text: String, orientation: Tooltip.Orientation, configuration: Tooltip.ToolTipConfiguration = Tooltip.ToolTipConfiguration()) {
        guard !hasActiveTooltip else { return }
        let label = UILabel()
        label.textAlignment = configuration.labelConfiguration.textAlignment
        label.textColor = configuration.labelConfiguration.textColor
        label.font = configuration.labelConfiguration.font
        label.numberOfLines = 0
        label.text = text
        label.preferredMaxLayoutWidth = configuration.labelConfiguration.preferredMaxLayoutWidth
        
        let toolTip = Tooltip(view: label, presentingView: self, orientation: orientation, configuration: configuration)
        
        UIApplication.shared.keyWindow?.addSubview(toolTip)
        
        toolTip.present()
    }
    
    /// Presents a tooltip to the calling view with a given view, orientation and configuration closure.
    ///
    /// - Parameter view    :The view that will be displayed within the tooltip
    /// - Parameter orientation: The placement of the tooltip in relation to the presenting view
    /// - Parameter configuration: A configuration closure allowing to customize the tooltip.
    public func tooltip(_ view: UIView, orientation: Tooltip.Orientation, configuration: ((Tooltip.ToolTipConfiguration) -> Tooltip.ToolTipConfiguration)) {
        tooltip(view, orientation: orientation, configuration: configuration(Tooltip.ToolTipConfiguration()))
    }
    
    /// Presents a tooltip to the calling view with a given text, orientation and configuration closure.
    ///
    /// - Parameter text    :The text that will be displayed within the tooltip
    /// - Parameter orientation: The placement of the tooltip in relation to the presenting view
    /// - Parameter configuration: A configuration closure allowing to customize the tooltip.
    public func tooltip(_ text: String, orientation: Tooltip.Orientation, configuration: ((Tooltip.ToolTipConfiguration) -> Tooltip.ToolTipConfiguration)) {
        tooltip(text, orientation: orientation, configuration: configuration(Tooltip.ToolTipConfiguration()))
    }
}

extension UIBarItem {
    
    // Taken from https://github.com/teodorpatras/EasyTipView/blob/8a9133085074c41119516a22b4223f79b8698b40/Sources/EasyTipView/UIKitExtensions.swift#L15
    fileprivate var view: UIView? {
        if let item = self as? UIBarButtonItem, let customView = item.customView {
            return customView
        }
        return self.value(forKey: "view") as? UIView
    }
    
    /// Presents a tooltip to the calling view with a given view, orientation and configuration.
    ///
    /// - Parameter view    :The view that will be displayed within the tooltip
    /// - Parameter orientation: The placement of the tooltip in relation to the presenting view
    /// - Parameter configuration: The configuration allowing to customize the tooltip
    public func tooltip(_ view: UIView, orientation: Tooltip.Orientation, configuration: Tooltip.ToolTipConfiguration = Tooltip.ToolTipConfiguration()) {
        guard let view = self.view else { return }
        view.tooltip(view, orientation: orientation, configuration: configuration)
    }
    
    /// Presents a tooltip to the calling view with a given view, orientation and configuration closure.
    ///
    /// - Parameter view    :The view that will be displayed within the tooltip
    /// - Parameter orientation: The placement of the tooltip in relation to the presenting view
    /// - Parameter configuration: A configuration closure allowing to customize the tooltip.
    public func tooltip(_ view: UIView, orientation: Tooltip.Orientation, configuration: ((Tooltip.ToolTipConfiguration) -> Tooltip.ToolTipConfiguration)) {
        guard let view = self.view else { return }
        view.tooltip(view, orientation: orientation, configuration: configuration)
    }
    
    /// Presents a tooltip to the calling view with a given text, orientation and configuration.
    ///
    /// - Parameter text    :The text that will be displayed within the tooltip
    /// - Parameter orientation: The placement of the tooltip in relation to the presenting view
    /// - Parameter configuration: The configuration allowing to customize the tooltip
    public func tooltip(_ text: String, orientation: Tooltip.Orientation, configuration: Tooltip.ToolTipConfiguration = Tooltip.ToolTipConfiguration()) {
        guard let view = self.view else { return }
        view.tooltip(text, orientation: orientation, configuration: configuration)
    }
    
    /// Presents a tooltip to the calling view with a given text, orientation and configuration closure.
    ///
    /// - Parameter text    :The text that will be displayed within the tooltip
    /// - Parameter orientation: The placement of the tooltip in relation to the presenting view
    /// - Parameter configuration: A configuration closure allowing to customize the tooltip.
    public func tooltip(_ text: String, orientation: Tooltip.Orientation, configuration: ((Tooltip.ToolTipConfiguration) -> Tooltip.ToolTipConfiguration)) {
        guard let view = self.view else { return }
        view.tooltip(text, orientation: orientation, configuration: configuration)
    }
}

extension Tooltip {
    /// Dismisses all tooltips that are currently shown on any sub view in the `keyWindow`.
    public static func dismissAll() {
        guard let activeTooltips = UIApplication.shared.keyWindow?.subviews.filter({ $0 is Tooltip }),
              !activeTooltips.isEmpty else { return }
        
        activeTooltips.compactMap { $0 as? Tooltip }.forEach { $0.dismiss() }
    }
}
