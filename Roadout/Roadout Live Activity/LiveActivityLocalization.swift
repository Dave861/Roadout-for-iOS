//
//  LiveActivityLocalization.swift
//  Roadout
//
//  Created by David Retegan on 25.04.2023.
//

import Foundation

extension String {
    func liveLocalize() -> String {
        return NSLocalizedString(self, tableName: "LiveActivityLocalizables", bundle: .main, value: self, comment: self)
    }
}

