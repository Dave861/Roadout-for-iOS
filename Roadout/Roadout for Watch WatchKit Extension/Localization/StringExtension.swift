//
//  StringExtension.swift
//  Roadout for Watch WatchKit Extension
//
//  Created by David Retegan on 20.09.2022.
//

import Foundation
import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
