//
//  CustomTableView.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//
import Foundation
import UIKit

final class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
