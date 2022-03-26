//
//  WatchLocalization.swift
//  Roadout Watch WatchKit Extension
//
//  Created by David Retegan on 20.03.2022.
//

import Foundation

extension String {
    func watchLocalize() -> String {
        return NSLocalizedString(self, tableName: "WatchLocalizables", bundle: .main, value: self, comment: self)
    }
}
