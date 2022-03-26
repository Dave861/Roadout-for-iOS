//
//  WidgetLocalization.swift
//  Roadout
//
//  Created by David Retegan on 20.03.2022.
//

import Foundation

extension String {
    func widgetLocalize() -> String {
        return NSLocalizedString(self, tableName: "WidgetLocalizables", bundle: .main, value: self, comment: self)
    }
}
